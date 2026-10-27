import 'package:qeema/core/financial/currency_converter.dart';
import 'package:qeema/core/financial/inflation_calculator.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/home/data/datasources/home_remote_datasource.dart';
import 'package:qeema/features/home/data/repositories/home_repository_impl_support.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl
    with HomeRepositoryImplSupport
    implements HomeRepository {
  HomeRepositoryImpl(
    this._assetsRepository,
    this._remoteDataSource,
    this._currencyConverter,
    this._inflationCalculator,
  );

  final AssetsRepository _assetsRepository;
  final HomeRemoteDataSource _remoteDataSource;
  final CurrencyConverter _currencyConverter;
  final InflationCalculator _inflationCalculator;

  @override
  AssetsRepository get assetsRepository => _assetsRepository;

  @override
  HomeRemoteDataSource get remoteDataSource => _remoteDataSource;

  @override
  CurrencyConverter get currencyConverter => _currencyConverter;

  @override
  InflationCalculator get inflationCalculator => _inflationCalculator;

  @override
  Future<ApiResult<DashboardSummaryEntity>> getDashboardSummary() async {
    final assetsResult = await _assetsRepository.getAssets();
    return assetsResult.fold(
      onSuccess: loadAssetTypes,
      onFailure: (failure) async => ResultFailure(failure),
    );
  }
}
