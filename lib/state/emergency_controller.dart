import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/emergency_alert.dart';
import '../data/repositories/emergency_repository.dart';

final allEmergenciesProvider = FutureProvider<List<EmergencyAlert>>((ref) async {
  final repo = ref.read(emergencyRepositoryProviderGlobal);
  return repo.getAllEmergencies();
});

final emergencyRepositoryProviderGlobal = Provider<EmergencyRepository>((ref) => EmergencyRepository());
