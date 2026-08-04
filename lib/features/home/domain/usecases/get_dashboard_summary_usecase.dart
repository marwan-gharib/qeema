import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/domain/repositories/home_repository.dart';

class GetDashboardSummaryUseCase
    implements UseCaseWithoutParams<DashboardSummaryEntity> {
  const GetDashboardSummaryUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<ApiResult<DashboardSummaryEntity>> call() =>
      _repository.getDashboardSummary();
}
