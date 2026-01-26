import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/patient.dart';
import 'risk_badge.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onTap;

  const PatientCard({
    super.key,
    required this.patient,
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
                      patient.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (patient.latestRiskLevel != null)
                    RiskBadge(riskLevel: patient.latestRiskLevel!),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${patient.age} years • ${patient.gender}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                patient.phoneNumber,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (patient.lastVisitDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Last visit: ${DateFormat('dd MMM yyyy').format(patient.lastVisitDate!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
              if (patient.hasHypertension || patient.hasDiabetes || patient.hasTbHistory) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: [
                    if (patient.hasHypertension)
                      Chip(
                        label: const Text('HTN', style: TextStyle(fontSize: 10)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    if (patient.hasDiabetes)
                      Chip(
                        label: const Text('DM', style: TextStyle(fontSize: 10)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    if (patient.hasTbHistory)
                      Chip(
                        label: const Text('TB Hx', style: TextStyle(fontSize: 10)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
