import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/data/datasources/assets_remote_datasource.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  const AssetsRepositoryImpl(this.remoteDataSource);

  final AssetsRemoteDataSource remoteDataSource;

  @override
  Future<ApiResult<List<AssetEntity>>> getAssets() async {
    try {
      final models = await remoteDataSource.getAssets();
      return Success(models);
    } on PostgrestException catch (e) {
      return ResultFailure(_mapSupabaseError(e));
    } catch (e) {
      return const ResultFailure(UnknownFailure());
    }
  }

  Failure _mapSupabaseError(PostgrestException e) {
    if (e.code == 'PGRST301' || (e.message.contains('JWT'))) {
      return const AuthFailure('انتهت صلاحية الجلسة، سجّل دخول تاني.');
    }
    return const ServerFailure('مش قادرين نجيب بياناتك دلوقتي، حاول تاني.');
  }
}
