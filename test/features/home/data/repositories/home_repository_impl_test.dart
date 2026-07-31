import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/home/data/models/market_price_row.dart';
import 'package:qeema/features/home/data/models/portfolio_snapshot_row.dart';
import 'package:qeema/features/home/data/repositories/home_repository_impl.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';

import 'mocks/mock_home_dependencies.dart';

const _usdType = AssetTypeEntity(
  id: 'type-usd',
  code: 'usd',
  name: 'USD',
  isMarketBased: true,
  baseUnit: 'USD',
);

const _egpType = AssetTypeEntity(
  id: 'type-egp',
  code: 'cash_egp',
  name: 'EGP',
  isMarketBased: false,
  baseUnit: 'EGP',
);

void main() {
  late MockGetAssetsUseCase assetsUseCase;
  late MockGetAssetTypesUseCase typesUseCase;
  late MockHomeRemoteDataSource remoteDataSource;
  late MockCurrencyConverter currencyConverter;
  late MockInflationCalculator inflationCalculator;
  late HomeRepositoryImpl repository;

  setUp(() {
    assetsUseCase = MockGetAssetsUseCase(
      result: Success([
        AssetEntity(
          id: 'a-usd',
          assetType: AssetType.usdCash,
          amount: 100,
          priceAtEntry: 30,
          entryDate: DateTime(2026, 6, 15),
        ),
      ]),
    );
    typesUseCase = MockGetAssetTypesUseCase(
      result: const Success([_usdType, _egpType]),
    );
    remoteDataSource = MockHomeRemoteDataSource();
    currencyConverter = MockCurrencyConverter(
      pricesByCode: {'usd': Decimal.fromInt(50)},
    );
    inflationCalculator = MockInflationCalculator();
    repository = HomeRepositoryImpl(
      assetsUseCase,
      typesUseCase,
      remoteDataSource,
      currencyConverter,
      inflationCalculator,
    );
  });

  group('HomeRepositoryImpl', () {
    test('returns error when assets fetch fails', () async {
      assetsUseCase.result = const ResultFailure(NetworkFailure());

      final result = await repository.getDashboardSummary();

      expect(result, isA<ResultFailure<DashboardSummaryEntity>>());
    });

    test('returns error when market prices fetch fails', () async {
      remoteDataSource.marketPricesResult = const ResultFailure(
        ServerFailure(),
      );

      final result = await repository.getDashboardSummary();

      expect(result, isA<ResultFailure<DashboardSummaryEntity>>());
    });

    test('returns error when inflation rates fetch fails', () async {
      remoteDataSource.inflationRatesResult = const ResultFailure(
        ServerFailure(),
      );

      final result = await repository.getDashboardSummary();

      expect(result, isA<ResultFailure<DashboardSummaryEntity>>());
    });

    test('returns error when portfolio snapshots fetch fails', () async {
      remoteDataSource.portfolioSnapshotsResult = const ResultFailure(
        ServerFailure(),
      );

      final result = await repository.getDashboardSummary();

      expect(result, isA<ResultFailure<DashboardSummaryEntity>>());
    });

    test(
      'aggregates nominal and real totals and maps trend from snapshots',
      () async {
        remoteDataSource.marketPricesResult = Success([
          MarketPriceRow(
            assetTypeCode: 'usd',
            priceDate: DateTime(2026, 7, 30),
            price: Decimal.fromInt(50),
          ),
        ]);
        remoteDataSource.portfolioSnapshotsResult = Success([
          PortfolioSnapshotRow(
            snapshotDate: DateTime(2026, 7, 30),
            totalNominalValue: Decimal.fromInt(5000),
            totalRealValue: Decimal.fromInt(4900),
          ),
        ]);
        inflationCalculator.result = Success(Decimal.fromInt(4800));

        final result = await repository.getDashboardSummary();

        final summary = (result as Success<DashboardSummaryEntity>).data;
        expect(summary.nominalTotal, Decimal.fromInt(5000));
        expect(summary.realTotal, Decimal.fromInt(4800));
        expect(summary.hasAssets, isTrue);
        expect(summary.trend30Days.single.realTotal, Decimal.fromInt(4900));
        expect(
          summary.assetTypeSummaries
              .firstWhere((s) => s.assetType.code == 'usd')
              .currentValue,
          Decimal.fromInt(5000),
        );
      },
    );

    test(
      'excludes asset from real total when inflation data is missing',
      () async {
        inflationCalculator.result = const ResultFailure(
          InflationDataMissingFailure([]),
        );

        final result = await repository.getDashboardSummary();

        final summary = (result as Success<DashboardSummaryEntity>).data;
        expect(summary.nominalTotal, Decimal.fromInt(5000));
        expect(summary.realTotal, Decimal.zero);
      },
    );

    test('computes day change from the two most recent price dates', () async {
      remoteDataSource.marketPricesResult = Success([
        MarketPriceRow(
          assetTypeCode: 'usd',
          priceDate: DateTime(2026, 7, 31),
          price: Decimal.parse('51'),
        ),
        MarketPriceRow(
          assetTypeCode: 'usd',
          priceDate: DateTime(2026, 7, 30),
          price: Decimal.parse('50'),
        ),
      ]);

      final result = await repository.getDashboardSummary();

      final summary = (result as Success<DashboardSummaryEntity>).data;
      final usd = summary.assetTypeSummaries.firstWhere(
        (s) => s.assetType.code == 'usd',
      );
      expect(usd.dayChangePercent, Decimal.fromInt(2));
      expect(usd.hasSufficientPriceHistory, isTrue);
    });

    test(
      'single price date yields zero day change flagged as insufficient history',
      () async {
        remoteDataSource.marketPricesResult = Success([
          MarketPriceRow(
            assetTypeCode: 'usd',
            priceDate: DateTime(2026, 7, 31),
            price: Decimal.fromInt(50),
          ),
        ]);

        final result = await repository.getDashboardSummary();

        final summary = (result as Success<DashboardSummaryEntity>).data;
        final usd = summary.assetTypeSummaries.firstWhere(
          (s) => s.assetType.code == 'usd',
        );
        expect(usd.dayChangePercent, Decimal.zero);
        expect(usd.hasSufficientPriceHistory, isFalse);
      },
    );

    test(
      'non-market asset is always flat regardless of price history',
      () async {
        final result = await repository.getDashboardSummary();

        final summary = (result as Success<DashboardSummaryEntity>).data;
        final egp = summary.assetTypeSummaries.firstWhere(
          (s) => s.assetType.code == 'cash_egp',
        );
        expect(egp.dayChangePercent, Decimal.zero);
      },
    );

    test('asset with no matching type is skipped', () async {
      assetsUseCase.result = Success([
        AssetEntity(
          id: 'a-unknown',
          assetType: AssetType.gold21,
          amount: 1,
          priceAtEntry: 3000,
          entryDate: DateTime(2026, 6, 15),
        ),
      ]);
      typesUseCase.result = const Success([_egpType]);

      final result = await repository.getDashboardSummary();

      final summary = (result as Success<DashboardSummaryEntity>).data;
      expect(summary.nominalTotal, Decimal.zero);
      expect(summary.hasAssets, isFalse);
    });
  });
}
