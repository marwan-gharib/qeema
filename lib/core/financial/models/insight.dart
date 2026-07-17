import 'package:qeema/core/financial/models/insight_severity.dart';
import 'package:qeema/core/financial/models/insight_type.dart';

class Insight {
  const Insight({
    required this.title,
    required this.body,
    required this.type,
    required this.severity,
  });
  final String title;
  final String body;
  final InsightType type;
  final InsightSeverity severity;
}
