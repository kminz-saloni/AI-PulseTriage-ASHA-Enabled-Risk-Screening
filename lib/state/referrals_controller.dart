import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/referral.dart';
import '../domain/referral_status.dart';
import '../data/repositories/referral_repository.dart';

final referralRepositoryProvider = Provider<ReferralRepository>((ref) => ReferralRepository());

final allReferralsProvider = FutureProvider<List<Referral>>((ref) async {
  final repo = ref.watch(referralRepositoryProvider);
  return repo.getAllReferrals();
});

final referralsByStatusProvider = FutureProvider.family<List<Referral>, ReferralStatus>((ref, status) async {
  final repo = ref.watch(referralRepositoryProvider);
  return repo.getReferralsByStatus(status);
});

final referralsByPatientProvider = FutureProvider.family<List<Referral>, String>((ref, patientId) async {
  final repo = ref.watch(referralRepositoryProvider);
  return repo.getReferralsByPatientId(patientId);
});
