import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qeema/core/financial/asset_valuator.dart';
import 'package:qeema/core/financial/currency_converter.dart';
import 'package:qeema/core/financial/financial_insight_engine.dart';
import 'package:qeema/core/financial/inflation_calculator.dart';
import 'package:qeema/core/financial/insight_rules/asset_performance_rule.dart';
import 'package:qeema/core/financial/insight_rules/concentration_risk_rule.dart';
import 'package:qeema/core/financial/insight_rules/goal_feasibility_rule.dart';
import 'package:qeema/core/financial/insight_rules/inflation_loss_rule.dart';
import 'package:qeema/core/financial/insight_rules/insight_rule.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/core/local/cache/cache_service_impl.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/local/cache/daos/goals_dao.dart';
import 'package:qeema/core/local/cache/daos/inflation_rates_dao.dart';
import 'package:qeema/core/local/cache/daos/market_prices_dao.dart';
import 'package:qeema/core/local/cache/daos/snapshots_dao.dart';
import 'package:qeema/core/local/secure/secure_storage_service.dart';
import 'package:qeema/core/local/secure/secure_storage_service_impl.dart';
import 'package:qeema/core/network/base_api_client.dart';
import 'package:qeema/core/network/dio_api_client.dart';
import 'package:qeema/core/network/network_info.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/network/supabase_query_executor.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/services/connectivity_service.dart';
import 'package:qeema/core/services/local_notification_service.dart';
import 'package:qeema/core/services/sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initCoreModule(GetIt getIt) async {
  getIt.registerLazySingleton<SupabaseClientProvider>(
    () => SupabaseClientProvider(),
  );
  getIt.registerLazySingleton<SupabaseQueryExecutor>(
    () => SupabaseQueryExecutor(getIt<SupabaseClientProvider>()),
  );

  getIt.registerLazySingleton<BaseApiClient>(
    () => DioApiClient(baseUrl: '', authInterceptor: null),
  );

  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(const FlutterSecureStorage()),
  );

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<CacheService>(() => CacheServiceImpl(prefs));

  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  getIt.registerLazySingleton<AssetsDao>(() => AssetsDao(getIt<AppDatabase>()));
  getIt.registerLazySingleton<MarketPricesDao>(
    () => MarketPricesDao(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<InflationRatesDao>(
    () => InflationRatesDao(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<SnapshotsDao>(
    () => SnapshotsDao(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<GoalsDao>(() => GoalsDao(getIt<AppDatabase>()));

  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(Connectivity()),
  );
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo(Connectivity()));

  getIt.registerLazySingleton<SyncService>(() => SyncService());
  getIt.registerLazySingleton<BiometricAuthService>(
    () => BiometricAuthService(LocalAuthentication()),
  );
  getIt.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(FlutterLocalNotificationsPlugin()),
  );

  getIt.registerLazySingleton<InflationCalculator>(() => InflationCalculator());
  getIt.registerLazySingleton<AssetValuator>(() => AssetValuator());
  getIt.registerLazySingleton<CurrencyConverter>(() => CurrencyConverter());

  getIt.registerFactory<InsightRule>(
    () => InflationLossRule(),
    instanceName: 'inflationLoss',
  );
  getIt.registerFactory<InsightRule>(
    () => AssetPerformanceRule(),
    instanceName: 'assetPerformance',
  );
  getIt.registerFactory<InsightRule>(
    () => ConcentrationRiskRule(),
    instanceName: 'concentrationRisk',
  );
  getIt.registerFactory<InsightRule>(
    () => GoalFeasibilityRule(),
    instanceName: 'goalFeasibility',
  );

  getIt.registerFactory<List<InsightRule>>(
    () => [
      getIt<InsightRule>(instanceName: 'inflationLoss'),
      getIt<InsightRule>(instanceName: 'assetPerformance'),
      getIt<InsightRule>(instanceName: 'concentrationRisk'),
      getIt<InsightRule>(instanceName: 'goalFeasibility'),
    ],
  );

  getIt.registerLazySingleton<FinancialInsightEngine>(
    () => FinancialInsightEngine(getIt<List<InsightRule>>()),
  );
}
