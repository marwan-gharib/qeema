import 'package:flutter/material.dart';

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
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [secondary, secondaryVariant]),
      ),
      child: Icon(Icons.wb_sunny, size: 60, color: iconColor),
    );
  }
}
