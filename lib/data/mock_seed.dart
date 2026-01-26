import '../domain/patient.dart';
import '../domain/visit.dart';
import '../domain/referral.dart';
import '../domain/task_item.dart';
import '../domain/incentive_entry.dart';
import '../domain/emergency_alert.dart';
import '../domain/risk_level.dart';
import '../domain/referral_status.dart';
import '../domain/task_status.dart';
import '../domain/incentive_status.dart';
import '../domain/risk_assessment.dart';

class MockSeed {
  static final List<Patient> patients = [
    Patient(
      id: 'p1',
      name: 'Rajesh Kumar',
      age: 55,
      gender: 'Male',
      address: 'Village Rampur, District Varanasi',
      phoneNumber: '+91 9876543210',
      latestRiskLevel: RiskLevel.yellow,
      lastVisitDate: DateTime.now().subtract(const Duration(days: 5)),
      hasHypertension: true,
      hasDiabetes: false,
      hasTbHistory: false,
    ),
    Patient(
      id: 'p2',
      name: 'Sunita Devi',
      age: 42,
      gender: 'Female',
      address: 'Village Kalyanpur, District Varanasi',
      phoneNumber: '+91 9876543211',
      latestRiskLevel: RiskLevel.green,
      lastVisitDate: DateTime.now().subtract(const Duration(days: 12)),
      hasHypertension: false,
      hasDiabetes: true,
      hasTbHistory: true,
    ),
  ];

  static final List<Visit> visits = [
    Visit(
      id: 'v1',
      patientId: 'p1',
      visitDate: DateTime.now().subtract(const Duration(days: 5)),
      systolicBp: 150,
      diastolicBp: 95,
      heartRate: 82,
      temperature: 37.2,
      weight: 72.5,
      symptoms: ['headache'],
      missedDoses: 2,
      riskAssessment: RiskAssessment(
        riskLevel: RiskLevel.yellow,
        reasons: ['Moderate hypertension (Stage 1)', 'Mild adherence concern - 1-2 missed doses'],
        recommendedAction: 'Schedule PHC visit within week',
        modelVersion: 'rules_v1',
        assessmentDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      notes: 'Patient reports occasional headaches',
    ),
  ];

  static final List<Referral> referrals = [
    Referral(
      id: 'r1',
      patientId: 'p1',
      patientName: 'Rajesh Kumar',
      status: ReferralStatus.open,
      urgency: 'Medium',
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      lastUpdate: DateTime.now().subtract(const Duration(days: 1)),
      reason: 'Uncontrolled hypertension with headaches',
      phcOutcome: null,
      notes: 'Patient agreed to visit PHC',
      patientInformed: true,
      hasTransportIssue: false,
    ),
    Referral(
      id: 'r2',
      patientId: 'p2',
      patientName: 'Sunita Devi',
      status: ReferralStatus.completed,
      urgency: 'Low',
      createdDate: DateTime.now().subtract(const Duration(days: 20)),
      lastUpdate: DateTime.now().subtract(const Duration(days: 10)),
      reason: 'Routine diabetes checkup',
      phcOutcome: 'Blood sugar levels stable, continue medication',
      notes: 'Completed visit on time',
      patientInformed: true,
      hasTransportIssue: false,
    ),
  ];

  static final List<TaskItem> tasks = [
    TaskItem(
      id: 't1',
      title: 'Follow-up visit for Rajesh Kumar',
      description: 'Check BP and adherence after PHC visit',
      status: TaskStatus.open,
      taskType: 'follow_up_visit',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      patientId: 'p1',
      patientName: 'Rajesh Kumar',
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    TaskItem(
      id: 't2',
      title: 'Adherence check for Sunita Devi',
      description: 'Verify medication adherence and refill needs',
      status: TaskStatus.open,
      taskType: 'adherence_check',
      dueDate: DateTime.now(),
      patientId: 'p2',
      patientName: 'Sunita Devi',
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TaskItem(
      id: 't3',
      title: 'PHC reminder follow-up',
      description: 'Confirm appointment with PHC for pending cases',
      status: TaskStatus.done,
      taskType: 'phc_reminder',
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static final List<IncentiveEntry> incentives = [
    IncentiveEntry(
      id: 'i1',
      description: 'Follow-up visit completed - Rajesh Kumar',
      amount: 50.0,
      status: IncentiveStatus.eligible,
      entryDate: DateTime.now().subtract(const Duration(days: 5)),
      taskId: 't1',
      notes: 'Visit completed successfully',
    ),
    IncentiveEntry(
      id: 'i2',
      description: 'Emergency alert handled - Critical case',
      amount: 100.0,
      status: IncentiveStatus.pending,
      entryDate: DateTime.now().subtract(const Duration(days: 10)),
      notes: 'Awaiting supervisor approval',
    ),
    IncentiveEntry(
      id: 'i3',
      description: 'Monthly health awareness session',
      amount: 200.0,
      status: IncentiveStatus.paid,
      entryDate: DateTime.now().subtract(const Duration(days: 30)),
      approvalDate: DateTime.now().subtract(const Duration(days: 20)),
      paymentDate: DateTime.now().subtract(const Duration(days: 15)),
      notes: 'Session conducted in village square',
    ),
  ];

  static final List<EmergencyAlert> emergencies = [
    EmergencyAlert(
      id: 'e1',
      patientId: 'p1',
      patientName: 'Rajesh Kumar',
      emergencyType: 'Severe Hypertension',
      description: 'Patient reported severe headache with BP 180/110',
      priority: 'High',
      createdDate: DateTime.now().subtract(const Duration(hours: 6)),
      isActive: true,
    ),
  ];
}
