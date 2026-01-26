import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/incentives_controller.dart';
import '../../ui/widgets/incentive_card.dart';
import '../../ui/widgets/section_header.dart';
import '../../ui/widgets/empty_state.dart';

class IncentiveTrackerScreen extends ConsumerWidget {
  const IncentiveTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incentivesAsync = ref.watch(allIncentivesProvider);
    final now = DateTime.now();
    final summaryAsync = ref.watch(monthlySummaryProvider((year: now.year, month: now.month)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incentive Tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allIncentivesProvider);
          ref.invalidate(monthlySummaryProvider((year: now.year, month: now.month)));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    summaryAsync.when(
                      data: (amount) => Text(
                        '₹${amount.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('Error'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Approved + Paid this month',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'All Entries'),
            incentivesAsync.when(
              data: (incentives) {
                if (incentives.isEmpty) {
                  return const EmptyState(
                    icon: Icons.attach_money,
                    message: 'No incentive entries',
                  );
                }

                return Column(
                  children: incentives.map((i) => IncentiveCard(incentive: i)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const EmptyState(
                icon: Icons.error,
                message: 'Error loading incentives',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
