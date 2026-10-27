import 'dart:convert';

import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/refresh_assets_usecase.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_summaries_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Standalone fakes and fixtures for the app-freeze regressions, split out of
/// `app_freeze_harness.dart` for FILE-1. Nothing here registers into `getIt`.

class FakeSupabaseClientProvider extends SupabaseClientProvider {
  @override
  SupabaseClient get client => fakeClient;

  static final SupabaseClient fakeClient = SupabaseClient(
    'https://qeema-test.supabase.co',
    'anon-test-key',
  );
}

class MockGetMarketPriceSummariesUseCase
    implements GetMarketPriceSummariesUseCase {
  ApiResult<List<MarketPriceSummaryEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<MarketPriceSummaryEntity>>> call({
    bool forceRefresh = false,
  }) async => result;
}

class MockGetDashboardSummaryUseCase implements GetDashboardSummaryUseCase {
  ApiResult<DashboardSummaryEntity> result = const ResultFailure(
    CacheFailure(),
  );

  @override
  Future<ApiResult<DashboardSummaryEntity>> call() async => result;
}

class MockGetAssetsUseCase implements GetAssetsUseCase {
  ApiResult<List<AssetEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<AssetEntity>>> call() async => result;

  @override
  AssetsRepository get repository => throw UnimplementedError();
}

class MockRefreshAssetsUseCase implements RefreshAssetsUseCase {
  ApiResult<List<AssetEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<AssetEntity>>> call() async => result;

  @override
  AssetsRepository get repository => throw UnimplementedError();
}

String fakeJwt() {
  final header = base64UrlEncode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
  final exp =
      DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch ~/
      1000;
  final payload = base64UrlEncode(
    utf8.encode('{"sub":"test-user","role":"authenticated","exp":$exp}'),
  );
  return '$header.$payload.fake-signature';
}

String fakeSessionJson() {
  return jsonEncode({
    'access_token': fakeJwt(),
    'refresh_token': 'fake-refresh-token',
    'expires_in': 3600,
    'token_type': 'bearer',
    'user': {
      'id': 'test-user',
      'aud': 'authenticated',
      'role': 'authenticated',
      'email': 'test@qeema.test',
      'app_metadata': {'provider': 'email'},
      'user_metadata': Map<String, dynamic>.from({}),
      'identities': [
        {
          'id': 'test-user',
          'user_id': 'test-user',
          'identity_data': {'sub': 'test-user'},
          'provider': 'email',
          'last_sign_in_at': null,
          'created_at': null,
          'updated_at': null,
        },
      ],
    },
  });
}
