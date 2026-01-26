import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/emergency_controller.dart';
import '../../ui/widgets/emergency_card.dart';
import '../../ui/widgets/empty_state.dart';

class EmergencyListScreen extends ConsumerWidget {
  const EmergencyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergenciesAsync = ref.watch(allEmergenciesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Emergencies'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allEmergenciesProvider);
        },
        child: emergenciesAsync.when(
          data: (emergencies) {
            if (emergencies.isEmpty) {
              return const EmptyState(
                icon: Icons.check_circle,
                message: 'No emergencies',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: emergencies.length,
              itemBuilder: (context, index) {
                return EmergencyCard(emergency: emergencies[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const EmptyState(
            icon: Icons.error,
            message: 'Error loading emergencies',
          ),
        ),
      ),
    );
  }
}
