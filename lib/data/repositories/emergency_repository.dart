import '../../domain/emergency_alert.dart';
import '../mock_seed.dart';

class EmergencyRepository {
  final List<EmergencyAlert> _emergencies = List.from(MockSeed.emergencies);

  Future<List<EmergencyAlert>> getAllEmergencies() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_emergencies);
  }

  Future<List<EmergencyAlert>> getActiveEmergencies() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _emergencies.where((e) => e.isActive).toList();
  }

  Future<List<EmergencyAlert>> getTop3ActiveEmergencies() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final active = _emergencies.where((e) => e.isActive).toList();
    active.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return active.take(3).toList();
  }

  Future<void> updateEmergency(EmergencyAlert emergency) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _emergencies.indexWhere((e) => e.id == emergency.id);
    if (index != -1) {
      _emergencies[index] = emergency;
    }
  }

  Future<void> addEmergency(EmergencyAlert emergency) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _emergencies.add(emergency);
  }
}
