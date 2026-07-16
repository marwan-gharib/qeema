enum InsightSeverity { info, attention }

enum InsightType {
  inflationLoss,
  assetPerformance,
  concentrationRisk,
  goalFeasibility,
}

class Insight {
  final String title;
  final String body;
  final InsightType type;
  final InsightSeverity severity;

  const Insight({
    required this.title,
    required this.body,
    required this.type,
    required this.severity,
  });
}
