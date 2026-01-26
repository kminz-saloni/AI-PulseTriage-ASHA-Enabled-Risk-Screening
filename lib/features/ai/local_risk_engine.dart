import '../../domain/risk_level.dart';
import '../../domain/risk_assessment.dart';

class LocalRiskEngine {
  static RiskAssessment assessRisk({
    required int systolicBp,
    required int diastolicBp,
    required List<String> symptoms,
    required int missedDoses,
    required bool hasTbHistory,
    required bool hasDiabetes,
    required bool hasHypertension,
  }) {
    final reasons = <String>[];
    RiskLevel riskLevel = RiskLevel.green;
    String recommendedAction = 'Continue routine monitoring';

    // Blood pressure assessment
    if (systolicBp >= 180 || diastolicBp >= 120) {
      riskLevel = RiskLevel.red;
      reasons.add('Critical hypertension detected (Stage 3)');
      recommendedAction = 'Immediate PHC referral required';
    } else if (systolicBp >= 160 || diastolicBp >= 100) {
      if (riskLevel == RiskLevel.green) riskLevel = RiskLevel.yellow;
      reasons.add('Severe hypertension (Stage 2)');
      if (recommendedAction == 'Continue routine monitoring') {
        recommendedAction = 'PHC consultation within 24 hours';
      }
    } else if (systolicBp >= 140 || diastolicBp >= 90) {
      if (riskLevel == RiskLevel.green) riskLevel = RiskLevel.yellow;
      reasons.add('Moderate hypertension (Stage 1)');
      if (recommendedAction == 'Continue routine monitoring') {
        recommendedAction = 'Schedule PHC visit within week';
      }
    }

    // Critical symptoms
    if (symptoms.contains('chest_pain')) {
      riskLevel = RiskLevel.red;
      reasons.add('Chest pain reported - cardiac risk');
      recommendedAction = 'Immediate PHC referral required';
    }

    if (symptoms.contains('breathlessness') && (systolicBp >= 140 || hasHypertension)) {
      if (riskLevel != RiskLevel.red) riskLevel = RiskLevel.yellow;
      reasons.add('Breathlessness with hypertension');
      if (!recommendedAction.contains('Immediate')) {
        recommendedAction = 'PHC consultation within 24 hours';
      }
    }

    if (symptoms.contains('severe_headache') && (systolicBp >= 160 || diastolicBp >= 100)) {
      riskLevel = RiskLevel.red;
      reasons.add('Severe headache with high BP - hypertensive emergency risk');
      recommendedAction = 'Immediate PHC referral required';
    }

    // Diabetes suspicion
    final diabetesSymptoms = ['polyuria', 'polydipsia', 'weight_loss'];
    final diabetesCount = symptoms.where((s) => diabetesSymptoms.contains(s)).length;
    if (diabetesCount >= 2 && !hasDiabetes) {
      if (riskLevel == RiskLevel.green) riskLevel = RiskLevel.yellow;
      reasons.add('Multiple diabetes symptoms detected');
      if (recommendedAction == 'Continue routine monitoring') {
        recommendedAction = 'Diabetes screening at PHC recommended';
      }
    }

    // TB relapse suspicion
    if (hasTbHistory) {
      final tbSymptoms = ['cough_2weeks', 'fever', 'weight_loss'];
      final tbCount = symptoms.where((s) => tbSymptoms.contains(s)).length;
      if (tbCount >= 2) {
        if (riskLevel == RiskLevel.green) riskLevel = RiskLevel.yellow;
        reasons.add('TB relapse suspected - history + symptoms');
        if (recommendedAction == 'Continue routine monitoring') {
          recommendedAction = 'TB screening at PHC required';
        }
      }
    }

    // Adherence risk
    if (missedDoses >= 5) {
      riskLevel = RiskLevel.red;
      reasons.add('Critical adherence issue - 5+ missed doses');
      if (!recommendedAction.contains('Immediate')) {
        recommendedAction = 'Immediate adherence counseling + PHC referral';
      }
    } else if (missedDoses >= 3) {
      if (riskLevel == RiskLevel.green) riskLevel = RiskLevel.yellow;
      reasons.add('Poor adherence - 3-4 missed doses');
      if (recommendedAction == 'Continue routine monitoring') {
        recommendedAction = 'Adherence counseling + follow-up visit';
      }
    } else if (missedDoses >= 1) {
      reasons.add('Mild adherence concern - 1-2 missed doses');
      if (recommendedAction == 'Continue routine monitoring') {
        recommendedAction = 'Adherence reminder + monitor closely';
      }
    }

    // Default low risk message
    if (reasons.isEmpty) {
      reasons.add('All vitals and adherence within normal range');
    }

    return RiskAssessment(
      riskLevel: riskLevel,
      reasons: reasons,
      recommendedAction: recommendedAction,
      modelVersion: 'rules_v1',
      assessmentDate: DateTime.now(),
    );
  }
}
