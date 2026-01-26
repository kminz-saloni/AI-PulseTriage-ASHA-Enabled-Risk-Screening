import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/emergency_alert.dart';

class EmergencyCard extends StatelessWidget {
  final EmergencyAlert emergency;
  final VoidCallback? onTap;

  const EmergencyCard({
    super.key,
    required this.emergency,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: emergency.isActive 
          ? Colors.red.withOpacity(0.1) 
          : Theme.of(context).cardColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: emergency.isActive ? Colors.red : Colors.grey,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emergency.patientName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          emergency.emergencyType,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.red,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(emergency.priority),
                    backgroundColor: _getPriorityColor(emergency.priority).withOpacity(0.2),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                emergency.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMM yyyy HH:mm').format(emergency.createdDate),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (!emergency.isActive && emergency.resolution != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Resolved: ${emergency.resolution}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
