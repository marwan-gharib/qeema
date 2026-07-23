import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';

class AssetValueChart extends StatelessWidget {
  const AssetValueChart({
    super.key,
    required this.isFlat,
    this.entryValue,
    this.currentValue,
  });
  final bool isFlat;
  final double? entryValue;
  final double? currentValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: isFlat
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 48,
                    color: context.colors.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cash assets maintain a constant value',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : const Center(
              child: Text('Chart area - market-based price history'),
            ),
    );
  }
}
