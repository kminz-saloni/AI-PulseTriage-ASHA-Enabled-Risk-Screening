import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/referral.dart';

class ReferralCard extends StatelessWidget {
  final Referral referral;
  final VoidCallback? onTap;

  const ReferralCard({
    super.key,
    required this.referral,
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
                      referral.patientName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Chip(
                    label: Text(
                      referral.urgency,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: _getUrgencyColor(referral.urgency).withOpacity(0.2),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                referral.reason,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    'Created: ${DateFormat('dd MMM').format(referral.createdDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.update, size: 14, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    'Updated: ${DateFormat('dd MMM').format(referral.lastUpdate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (referral.phcOutcome != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'PHC: ${referral.phcOutcome}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  if (referral.patientInformed)
                    const Chip(
                      label: Text('Informed', style: TextStyle(fontSize: 10)),
                      avatar: Icon(Icons.check_circle, size: 16),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  if (referral.hasTransportIssue)
                    const Chip(
                      label: Text('Transport Issue', style: TextStyle(fontSize: 10)),
                      avatar: Icon(Icons.directions_car, size: 16),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
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
