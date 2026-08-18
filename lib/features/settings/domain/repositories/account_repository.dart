import 'package:qeema/core/utils/api_result.dart';

abstract class AccountRepository {
  Future<ApiResult<void>> deleteAccount();
}
