import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/task_status.dart';
import '../../state/tasks_controller.dart';
import '../../ui/widgets/task_card.dart';
import '../../ui/widgets/empty_state.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Open'),
            Tab(text: 'Done'),
            Tab(text: 'Blocked'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TaskList(status: TaskStatus.open),
          _TaskList(status: TaskStatus.done),
          _TaskList(status: TaskStatus.blocked),
        ],
      ),
    );
  }
}

class _TaskList extends ConsumerWidget {
  final TaskStatus status;

  const _TaskList({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksByStatusProvider(status));

    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return EmptyState(
            icon: Icons.task_alt,
            message: 'No ${status.displayName.toLowerCase()} tasks',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(tasksByStatusProvider(status));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                onComplete: status == TaskStatus.open
                    ? () {
                        // Quick complete task
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Task marked complete')),
                        );
                        ref.invalidate(tasksByStatusProvider(status));
                      }
                    : null,
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const EmptyState(
        icon: Icons.error,
        message: 'Error loading tasks',
      ),
    );
  }
}
