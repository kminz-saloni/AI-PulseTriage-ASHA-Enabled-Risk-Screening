import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/incentive_entry.dart';
import '../domain/incentive_status.dart';
import '../data/repositories/incentive_repository.dart';

final incentiveRepositoryProvider = Provider<IncentiveRepository>((ref) => IncentiveRepository());

final allIncentivesProvider = FutureProvider<List<IncentiveEntry>>((ref) async {
  final repo = ref.watch(incentiveRepositoryProvider);
  return repo.getAllIncentives();
});

final incentivesByStatusProvider = FutureProvider.family<List<IncentiveEntry>, IncentiveStatus>((ref, status) async {
  final repo = ref.watch(incentiveRepositoryProvider);
  return repo.getIncentivesByStatus(status);
});

final monthlySummaryProvider = FutureProvider.family<double, ({int year, int month})>((ref, params) async {
  final repo = ref.watch(incentiveRepositoryProvider);
  return repo.getMonthlySummary(params.year, params.month);
});
