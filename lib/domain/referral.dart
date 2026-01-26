import 'referral_status.dart';

class Referral {
  final String id;
  final String patientId;
  final String patientName;
  final ReferralStatus status;
  final String urgency;
  final DateTime createdDate;
  final DateTime lastUpdate;
  final String reason;
  final String? phcOutcome;
  final String? notes;
  final bool patientInformed;
  final bool hasTransportIssue;

  const Referral({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.status,
    required this.urgency,
    required this.createdDate,
    required this.lastUpdate,
    required this.reason,
    this.phcOutcome,
    this.notes,
    this.patientInformed = false,
    this.hasTransportIssue = false,
  });

  Referral copyWith({
    String? id,
    String? patientId,
    String? patientName,
    ReferralStatus? status,
    String? urgency,
    DateTime? createdDate,
    DateTime? lastUpdate,
    String? reason,
    String? phcOutcome,
    String? notes,
    bool? patientInformed,
    bool? hasTransportIssue,
  }) {
    return Referral(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      status: status ?? this.status,
      urgency: urgency ?? this.urgency,
      createdDate: createdDate ?? this.createdDate,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      reason: reason ?? this.reason,
      phcOutcome: phcOutcome ?? this.phcOutcome,
      notes: notes ?? this.notes,
      patientInformed: patientInformed ?? this.patientInformed,
      hasTransportIssue: hasTransportIssue ?? this.hasTransportIssue,
    );
  }
}
