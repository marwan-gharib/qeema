import 'package:qeema/core/financial/currency_converter.dart';
import 'package:qeema/core/financial/inflation_calculator.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/home/data/datasources/home_remote_datasource.dart';
import 'package:qeema/features/home/data/repositories/home_repository_impl_support.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl
    with HomeRepositoryImplSupport
    implements HomeRepository {
  HomeRepositoryImpl(
    this._getAssetsUseCase,
    this._getAssetTypesUseCase,
    this._remoteDataSource,
    this._currencyConverter,
    this._inflationCalculator,
  );

  final GetAssetsUseCase _getAssetsUseCase;
  final GetAssetTypesUseCase _getAssetTypesUseCase;
  final HomeRemoteDataSource _remoteDataSource;
  final CurrencyConverter _currencyConverter;
  final InflationCalculator _inflationCalculator;

  @override
  GetAssetsUseCase get getAssetsUseCase => _getAssetsUseCase;

  @override
  GetAssetTypesUseCase get getAssetTypesUseCase => _getAssetTypesUseCase;

  @override
  HomeRemoteDataSource get remoteDataSource => _remoteDataSource;

  @override
  CurrencyConverter get currencyConverter => _currencyConverter;

  @override
  InflationCalculator get inflationCalculator => _inflationCalculator;

  @override
  Future<ApiResult<DashboardSummaryEntity>> getDashboardSummary() async {
    final assetsResult = await _getAssetsUseCase.call();
    return assetsResult.fold(
      onSuccess: loadAssetTypes,
      onFailure: (failure) async => ResultFailure(failure),
    );
  }
}
