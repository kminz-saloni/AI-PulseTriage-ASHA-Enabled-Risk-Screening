import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/task_item.dart';
import '../domain/task_status.dart';
import '../data/repositories/task_repository.dart';

final allTasksProvider = FutureProvider<List<TaskItem>>((ref) async {
  final repo = ref.read(taskRepositoryProvider);
  return repo.getAllTasks();
});

final tasksByStatusProvider = FutureProvider.family<List<TaskItem>, TaskStatus>((ref, status) async {
  final repo = ref.read(taskRepositoryProvider);
  return repo.getTasksByStatus(status);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) => TaskRepository());
