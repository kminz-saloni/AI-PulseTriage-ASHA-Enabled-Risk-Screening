import '../../domain/incentive_entry.dart';
import '../../domain/incentive_status.dart';
import '../mock_seed.dart';

class IncentiveRepository {
  final List<IncentiveEntry> _incentives = List.from(MockSeed.incentives);

  Future<List<IncentiveEntry>> getAllIncentives() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_incentives);
  }

  Future<List<IncentiveEntry>> getIncentivesByStatus(IncentiveStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _incentives.where((i) => i.status == status).toList();
  }

  Future<double> getMonthlySummary(int year, int month) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _incentives
        .where((i) =>
            i.entryDate.year == year &&
            i.entryDate.month == month &&
            (i.status == IncentiveStatus.approved || i.status == IncentiveStatus.paid))
        .fold<double>(0.0, (sum, i) => sum + i.amount);
  }

  Future<void> updateIncentive(IncentiveEntry incentive) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _incentives.indexWhere((i) => i.id == incentive.id);
    if (index != -1) {
      _incentives[index] = incentive;
    }
  }

  Future<void> addIncentive(IncentiveEntry incentive) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _incentives.add(incentive);
  }
}
