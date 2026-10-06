import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_sizes.dart';

class GetStartedIllustration extends StatelessWidget {
  const GetStartedIllustration({
    super.key,
    required this.secondary,
    required this.secondaryVariant,
    required this.iconColor,
  });
  final Color secondary;
  final Color secondaryVariant;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.width(120),
      height: Responsive.height(120),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [secondary, secondaryVariant]),
      ),
      child: Icon(
        Icons.wb_sunny,
        size: AppSizes.iconIllustration,
        color: iconColor,
      ),
    );
  }
}
