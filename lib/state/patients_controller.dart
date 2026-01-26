import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/patient.dart';
import '../data/repositories/patient_repository.dart';

final patientRepositoryProvider = Provider<PatientRepository>((ref) => PatientRepository());

final allPatientsProvider = FutureProvider<List<Patient>>((ref) async {
  final repo = ref.watch(patientRepositoryProvider);
  return repo.getAllPatients();
});

final patientByIdProvider = FutureProvider.family<Patient?, String>((ref, id) async {
  final repo = ref.watch(patientRepositoryProvider);
  return repo.getPatientById(id);
});
