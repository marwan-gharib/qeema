import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/home/data/datasources/home_remote_datasource.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/domain/repositories/home_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this.remoteDataSource);

  final HomeRemoteDataSource remoteDataSource;

  @override
  Future<ApiResult<DashboardSummaryEntity>> getDashboardSummary() async {
    try {
      final summary = await remoteDataSource.getDashboardSummary();
      return Success(summary);
    } on PostgrestException catch (e) {
      return ResultFailure(_mapSupabaseError(e));
    } catch (e) {
      return const ResultFailure(
        ServerFailure(
          'Something went wrong loading your dashboard. Please try again.',
        ),
      );
    }
  }

  Failure _mapSupabaseError(PostgrestException e) {
    if (e.code == 'PGRST301' || e.message.contains('JWT')) {
      return const AuthFailure(
        'Your session has expired. Please log in again.',
      );
    }
    return const ServerFailure(
      'We could not load your dashboard right now. Please try again.',
    );
  }
}
