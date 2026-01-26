import 'incentive_status.dart';

class IncentiveEntry {
  final String id;
  final String description;
  final double amount;
  final IncentiveStatus status;
  final DateTime entryDate;
  final String? taskId;
  final String? notes;
  final DateTime? approvalDate;
  final DateTime? paymentDate;

  const IncentiveEntry({
    required this.id,
    required this.description,
    required this.amount,
    required this.status,
    required this.entryDate,
    this.taskId,
    this.notes,
    this.approvalDate,
    this.paymentDate,
  });

  IncentiveEntry copyWith({
    String? id,
    String? description,
    double? amount,
    IncentiveStatus? status,
    DateTime? entryDate,
    String? taskId,
    String? notes,
    DateTime? approvalDate,
    DateTime? paymentDate,
  }) {
    return IncentiveEntry(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      entryDate: entryDate ?? this.entryDate,
      taskId: taskId ?? this.taskId,
      notes: notes ?? this.notes,
      approvalDate: approvalDate ?? this.approvalDate,
      paymentDate: paymentDate ?? this.paymentDate,
    );
  }
}
