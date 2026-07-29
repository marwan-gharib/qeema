import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/domain/repositories/home_repository.dart';

class GetDashboardSummaryUseCase {
  const GetDashboardSummaryUseCase(this.repository);

  final HomeRepository repository;

  Future<ApiResult<DashboardSummaryEntity>> call() =>
      repository.getDashboardSummary();
}
