import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/patients_controller.dart';
import '../../ui/widgets/patient_card.dart';
import '../../ui/widgets/empty_state.dart';

class PatientListScreen extends ConsumerStatefulWidget {
  const PatientListScreen({super.key});

  @override
  ConsumerState<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends ConsumerState<PatientListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(allPatientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search patients...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: patientsAsync.when(
              data: (patients) {
                final filtered = _searchQuery.isEmpty
                    ? patients
                    : patients.where((p) =>
                        p.name.toLowerCase().contains(_searchQuery) ||
                        p.phoneNumber.contains(_searchQuery)).toList();

                if (filtered.isEmpty) {
                  return const EmptyState(
                    icon: Icons.person_off,
                    message: 'No patients found',
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final patient = filtered[index];
                    return PatientCard(
                      patient: patient,
                      onTap: () => context.push('/patient/${patient.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const EmptyState(
                icon: Icons.error,
                message: 'Error loading patients',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
