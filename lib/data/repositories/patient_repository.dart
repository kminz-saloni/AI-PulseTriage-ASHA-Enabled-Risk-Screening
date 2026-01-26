import '../../domain/patient.dart';
import '../mock_seed.dart';

class PatientRepository {
  final List<Patient> _patients = List.from(MockSeed.patients);

  Future<List<Patient>> getAllPatients() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_patients);
  }

  Future<Patient?> getPatientById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _patients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Patient>> searchPatients(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _patients.where((p) =>
      p.name.toLowerCase().contains(lowerQuery) ||
      p.phoneNumber.contains(query)
    ).toList();
  }

  Future<void> updatePatient(Patient patient) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _patients.indexWhere((p) => p.id == patient.id);
    if (index != -1) {
      _patients[index] = patient;
    }
  }

  Future<void> addPatient(Patient patient) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _patients.add(patient);
  }
}
