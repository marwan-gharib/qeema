import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';

abstract class HomeRepository {
  Future<ApiResult<DashboardSummaryEntity>> getDashboardSummary();
}
