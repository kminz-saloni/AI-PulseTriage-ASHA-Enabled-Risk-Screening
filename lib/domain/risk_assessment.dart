import 'risk_level.dart';

class RiskAssessment {
  final RiskLevel riskLevel;
  final List<String> reasons;
  final String recommendedAction;
  final String modelVersion;
  final DateTime assessmentDate;

  const RiskAssessment({
    required this.riskLevel,
    required this.reasons,
    required this.recommendedAction,
    required this.modelVersion,
    required this.assessmentDate,
  });

  RiskAssessment copyWith({
    RiskLevel? riskLevel,
    List<String>? reasons,
    String? recommendedAction,
    String? modelVersion,
    DateTime? assessmentDate,
  }) {
    return RiskAssessment(
      riskLevel: riskLevel ?? this.riskLevel,
      reasons: reasons ?? this.reasons,
      recommendedAction: recommendedAction ?? this.recommendedAction,
      modelVersion: modelVersion ?? this.modelVersion,
      assessmentDate: assessmentDate ?? this.assessmentDate,
    );
  }
}
