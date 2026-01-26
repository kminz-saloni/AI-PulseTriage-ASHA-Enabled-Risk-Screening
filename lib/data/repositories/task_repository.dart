import '../../domain/task_item.dart';
import '../../domain/task_status.dart';
import '../mock_seed.dart';

class TaskRepository {
  final List<TaskItem> _tasks = List.from(MockSeed.tasks);

  Future<List<TaskItem>> getAllTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_tasks);
  }

  Future<List<TaskItem>> getTasksByStatus(TaskStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tasks.where((t) => t.status == status).toList();
  }

  Future<List<TaskItem>> getTasksDueToday() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return _tasks.where((t) =>
      t.status == TaskStatus.open &&
      t.dueDate.year == now.year &&
      t.dueDate.month == now.month &&
      t.dueDate.day == now.day
    ).toList();
  }

  Future<List<TaskItem>> getOverdueTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return _tasks.where((t) =>
      t.status == TaskStatus.open &&
      t.dueDate.isBefore(now)
    ).toList();
  }

  Future<void> updateTask(TaskItem task) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  Future<void> addTask(TaskItem task) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tasks.add(task);
  }
}
