import 'task_status.dart';

class TaskItem {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final String taskType;
  final DateTime dueDate;
  final String? patientId;
  final String? patientName;
  final String? notes;
  final DateTime createdDate;

  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.taskType,
    required this.dueDate,
    this.patientId,
    this.patientName,
    this.notes,
    required this.createdDate,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    String? taskType,
    DateTime? dueDate,
    String? patientId,
    String? patientName,
    String? notes,
    DateTime? createdDate,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      taskType: taskType ?? this.taskType,
      dueDate: dueDate ?? this.dueDate,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      notes: notes ?? this.notes,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
