import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/task_item.dart';
import '../domain/emergency_alert.dart';
import '../data/repositories/task_repository.dart';
import '../data/repositories/emergency_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) => TaskRepository());
final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) => EmergencyRepository());

final todaysTasksProvider = FutureProvider<List<TaskItem>>((ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksDueToday();
});

final overdueTasksProvider = FutureProvider<List<TaskItem>>((ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getOverdueTasks();
});

final activeEmergenciesProvider = FutureProvider<List<EmergencyAlert>>((ref) async {
  final repo = ref.watch(emergencyRepositoryProvider);
  return repo.getTop3ActiveEmergencies();
});
