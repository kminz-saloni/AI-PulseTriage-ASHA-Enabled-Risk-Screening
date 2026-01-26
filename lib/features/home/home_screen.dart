import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/home_controller.dart';
import '../../state/sync_controller.dart';
import '../../state/app_settings_controller.dart';
import '../../ui/widgets/sync_status_pill.dart';
import '../../ui/widgets/task_card.dart';
import '../../ui/widgets/emergency_card.dart';
import '../../ui/widgets/section_header.dart';
import '../../ui/widgets/empty_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysTasks = ref.watch(todaysTasksProvider);
    final overdueTasks = ref.watch(overdueTasksProvider);
    final emergencies = ref.watch(activeEmergenciesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              ref.read(appSettingsControllerProvider.notifier).toggleLanguage();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todaysTasksProvider);
          ref.invalidate(overdueTasksProvider);
          ref.invalidate(activeEmergenciesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SyncStatusPill(),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Active Emergencies'),
            emergencies.when(
              data: (data) => data.isEmpty
                  ? const EmptyState(
                      icon: Icons.check_circle,
                      message: 'No active emergencies',
                    )
                  : Column(
                      children: data.map((e) => EmergencyCard(emergency: e)).toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const EmptyState(
                icon: Icons.error,
                message: 'Error loading emergencies',
              ),
            ),
            const SizedBox(height: 16),
            SectionHeader(
              title: 'Today\'s Tasks',
              trailing: 'View All',
              onTrailingTap: () => context.go('/tasks'),
            ),
            todaysTasks.when(
              data: (data) => data.isEmpty
                  ? const EmptyState(
                      icon: Icons.task_alt,
                      message: 'No tasks due today',
                    )
                  : Column(
                      children: data.map((t) => TaskCard(task: t)).toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const EmptyState(
                icon: Icons.error,
                message: 'Error loading tasks',
              ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Overdue Tasks'),
            overdueTasks.when(
              data: (data) => data.isEmpty
                  ? const EmptyState(
                      icon: Icons.done_all,
                      message: 'No overdue tasks',
                    )
                  : Column(
                      children: data.map((t) => TaskCard(task: t)).toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const EmptyState(
                icon: Icons.error,
                message: 'Error loading overdue tasks',
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Quick Actions'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _QuickActionCard(
                  icon: Icons.add_circle,
                  label: 'New Visit',
                  color: Colors.teal,
                  onTap: () => context.push('/new-visit'),
                ),
                _QuickActionCard(
                  icon: Icons.warning,
                  label: 'Emergency Alert',
                  color: Colors.red,
                  onTap: () => context.push('/emergency-create'),
                ),
                _QuickActionCard(
                  icon: Icons.search,
                  label: 'Search Patient',
                  color: Colors.blue,
                  onTap: () => context.go('/patients'),
                ),
                _QuickActionCard(
                  icon: Icons.list_alt,
                  label: 'Emergencies',
                  color: Colors.orange,
                  onTap: () => context.push('/emergency-list'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
