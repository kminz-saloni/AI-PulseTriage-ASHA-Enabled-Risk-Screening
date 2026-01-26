import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/incentive_entry.dart';
import '../../domain/incentive_status.dart';

class IncentiveCard extends StatelessWidget {
  final IncentiveEntry incentive;
  final VoidCallback? onTap;

  const IncentiveCard({
    super.key,
    required this.incentive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                      incentive.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '₹${incentive.amount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMM yyyy').format(incentive.entryDate),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(_getStatusLabel(incentive.status)),
                backgroundColor: _getStatusColor(incentive.status).withOpacity(0.2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              if (incentive.notes != null) ...[
                const SizedBox(height: 8),
                Text(
                  incentive.notes!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(IncentiveStatus status) {
    switch (status) {
      case IncentiveStatus.paid:
        return Colors.green;
      case IncentiveStatus.approved:
        return Colors.blue;
      case IncentiveStatus.pending:
        return Colors.orange;
      case IncentiveStatus.eligible:
        return Colors.purple;
    }
  }

  String _getStatusLabel(IncentiveStatus status) {
    switch (status) {
      case IncentiveStatus.paid:
        return 'Paid';
      case IncentiveStatus.approved:
        return 'Approved';
      case IncentiveStatus.pending:
        return 'Pending';
      case IncentiveStatus.eligible:
        return 'Eligible';
    }
  }
}
