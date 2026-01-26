import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/task_item.dart';
import '../../domain/task_status.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.dueDate.isBefore(DateTime.now()) && task.status == TaskStatus.open;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (onComplete != null && task.status == TaskStatus.open)
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      color: Colors.green,
                      onPressed: onComplete,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                task.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isOverdue ? Icons.warning : Icons.calendar_today,
                    size: 14,
                    color: isOverdue ? Colors.red : Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Due: ${DateFormat('dd MMM yyyy').format(task.dueDate)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isOverdue ? Colors.red : null,
                        ),
                  ),
                ],
              ),
              if (task.patientName != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      task.patientName!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Chip(
                label: Text(task.taskType.replaceAll('_', ' ').toUpperCase()),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
