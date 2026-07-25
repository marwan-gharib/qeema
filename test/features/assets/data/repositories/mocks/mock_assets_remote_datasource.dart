import 'package:qeema/features/assets/data/datasources/assets_remote_datasource.dart';

class MockAssetsRemoteDataSource implements AssetsRemoteDataSource {
  MockAssetsRemoteDataSource();

  List<Map<String, dynamic>> assetTypesResult = [];
  List<AssetModelFromServer> assetsResult = [];
  Map<String, dynamic> addAssetResult = {};
  bool shouldThrow = false;

  @override
  Future<List<AssetModelFromServer>> getAssets() async {
    if (shouldThrow) throw Exception('mock error');
    return assetsResult;
  }

  @override
  Future<List<Map<String, dynamic>>> getAssetTypes() async {
    if (shouldThrow) throw Exception('mock error');
    return assetTypesResult;
  }

  @override
  Future<Map<String, dynamic>> addAsset(Map<String, dynamic> assetData) async {
    if (shouldThrow) throw Exception('mock error');
    return addAssetResult;
  }
}
