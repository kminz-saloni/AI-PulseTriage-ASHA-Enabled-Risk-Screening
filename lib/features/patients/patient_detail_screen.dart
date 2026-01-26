import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/patients_controller.dart';
import '../../state/referrals_controller.dart';
import '../../ui/widgets/risk_badge.dart';
import '../../ui/widgets/section_header.dart';
import '../../ui/widgets/referral_card.dart';
import '../../ui/widgets/empty_state.dart';

class PatientDetailScreen extends ConsumerWidget {
  final String patientId;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(patientByIdProvider(patientId));
    final referralsAsync = ref.watch(referralsByPatientProvider(patientId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
      ),
      body: patientAsync.when(
        data: (patient) {
          if (patient == null) {
            return const EmptyState(
              icon: Icons.person_off,
              message: 'Patient not found',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            patient.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          if (patient.latestRiskLevel != null)
                            RiskBadge(riskLevel: patient.latestRiskLevel!, size: 32),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _DetailRow(icon: Icons.cake, label: '${patient.age} years old'),
                      _DetailRow(icon: Icons.person, label: patient.gender),
                      _DetailRow(icon: Icons.phone, label: patient.phoneNumber),
                      _DetailRow(icon: Icons.location_on, label: patient.address),
                      const SizedBox(height: 16),
                      if (patient.hasHypertension || patient.hasDiabetes || patient.hasTbHistory) ...[
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          'Medical History',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (patient.hasHypertension)
                              const Chip(label: Text('Hypertension')),
                            if (patient.hasDiabetes)
                              const Chip(label: Text('Diabetes')),
                            if (patient.hasTbHistory)
                              const Chip(label: Text('TB History')),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/new-visit?patientId=$patientId'),
                      icon: const Icon(Icons.add),
                      label: const Text('New Visit'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/emergency-create?patientId=$patientId'),
                      icon: const Icon(Icons.warning),
                      label: const Text('Emergency'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Referrals'),
              referralsAsync.when(
                data: (referrals) => referrals.isEmpty
                    ? const EmptyState(
                        icon: Icons.local_hospital,
                        message: 'No referrals',
                      )
                    : Column(
                        children: referrals.map((r) => ReferralCard(referral: r)).toList(),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const EmptyState(
                  icon: Icons.error,
                  message: 'Error loading referrals',
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const EmptyState(
          icon: Icons.error,
          message: 'Error loading patient',
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
