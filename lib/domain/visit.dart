import 'risk_assessment.dart';

class Visit {
  final String id;
  final String patientId;
  final DateTime visitDate;
  final int systolicBp;
  final int diastolicBp;
  final int heartRate;
  final double temperature;
  final double weight;
  final List<String> symptoms;
  final int missedDoses;
  final RiskAssessment riskAssessment;
  final String? notes;

  const Visit({
    required this.id,
    required this.patientId,
    required this.visitDate,
    required this.systolicBp,
    required this.diastolicBp,
    required this.heartRate,
    required this.temperature,
    required this.weight,
    required this.symptoms,
    required this.missedDoses,
    required this.riskAssessment,
    this.notes,
  });

  Visit copyWith({
    String? id,
    String? patientId,
    DateTime? visitDate,
    int? systolicBp,
    int? diastolicBp,
    int? heartRate,
    double? temperature,
    double? weight,
    List<String>? symptoms,
    int? missedDoses,
    RiskAssessment? riskAssessment,
    String? notes,
  }) {
    return Visit(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      visitDate: visitDate ?? this.visitDate,
      systolicBp: systolicBp ?? this.systolicBp,
      diastolicBp: diastolicBp ?? this.diastolicBp,
      heartRate: heartRate ?? this.heartRate,
      temperature: temperature ?? this.temperature,
      weight: weight ?? this.weight,
      symptoms: symptoms ?? this.symptoms,
      missedDoses: missedDoses ?? this.missedDoses,
      riskAssessment: riskAssessment ?? this.riskAssessment,
      notes: notes ?? this.notes,
    );
  }
}
