import '../../domain/referral.dart';
import '../../domain/referral_status.dart';
import '../mock_seed.dart';

class ReferralRepository {
  final List<Referral> _referrals = List.from(MockSeed.referrals);

  Future<List<Referral>> getAllReferrals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_referrals);
  }

  Future<List<Referral>> getReferralsByStatus(ReferralStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _referrals.where((r) => r.status == status).toList();
  }

  Future<List<Referral>> getReferralsByPatientId(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _referrals.where((r) => r.patientId == patientId).toList();
  }

  Future<void> updateReferral(Referral referral) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _referrals.indexWhere((r) => r.id == referral.id);
    if (index != -1) {
      _referrals[index] = referral;
    }
  }

  Future<void> addReferral(Referral referral) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _referrals.add(referral);
  }
}
