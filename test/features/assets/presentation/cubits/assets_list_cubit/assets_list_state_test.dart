import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_state.dart';

AssetEntity _asset(DateTime entryDate) => AssetEntity(
  id: 'asset-${entryDate.millisecondsSinceEpoch}',
  assetType: AssetType.usdCash,
  amount: 1,
  priceAtEntry: 1,
  entryDate: entryDate,
);

void main() {
  test('visibleAssets sorts a copy of an unmodifiable allAssets list', () {
    final state = AssetsListLoaded(
      allAssets: List.unmodifiable([
        _asset(DateTime(2026, 1, 1)),
        _asset(DateTime(2026, 3, 1)),
        _asset(DateTime(2026, 2, 1)),
      ]),
    );

    final visible = state.visibleAssets;

    expect(visible.map((a) => a.entryDate), [
      DateTime(2026, 3, 1),
      DateTime(2026, 2, 1),
      DateTime(2026, 1, 1),
    ]);
  });

  test('visibleAssets does not mutate allAssets', () {
    final allAssets = [
      _asset(DateTime(2026, 1, 1)),
      _asset(DateTime(2026, 3, 1)),
    ];
    final state = AssetsListLoaded(allAssets: allAssets);

    state.visibleAssets;

    expect(allAssets.map((a) => a.entryDate), [
      DateTime(2026, 1, 1),
      DateTime(2026, 3, 1),
    ]);
  });
}
