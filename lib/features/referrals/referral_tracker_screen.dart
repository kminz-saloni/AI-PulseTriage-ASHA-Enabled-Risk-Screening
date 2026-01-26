import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/referral_status.dart';
import '../../state/referrals_controller.dart';
import '../../ui/widgets/referral_card.dart';
import '../../ui/widgets/empty_state.dart';

class ReferralTrackerScreen extends ConsumerStatefulWidget {
  const ReferralTrackerScreen({super.key});

  @override
  ConsumerState<ReferralTrackerScreen> createState() => _ReferralTrackerScreenState();
}

class _ReferralTrackerScreenState extends ConsumerState<ReferralTrackerScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Tracker'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Open'),
            Tab(text: 'Partial'),
            Tab(text: 'Completed'),
            Tab(text: 'Hospital Issue'),
            Tab(text: 'Other'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ReferralList(status: ReferralStatus.open),
          _ReferralList(status: ReferralStatus.partial),
          _ReferralList(status: ReferralStatus.completed),
          _ReferralList(status: ReferralStatus.hospitalIssue),
          _ReferralList(status: ReferralStatus.other),
        ],
      ),
    );
  }
}

class _ReferralList extends ConsumerWidget {
  final ReferralStatus status;

  const _ReferralList({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referralsAsync = ref.watch(referralsByStatusProvider(status));

    return referralsAsync.when(
      data: (referrals) {
        if (referrals.isEmpty) {
          return EmptyState(
            icon: Icons.local_hospital,
            message: 'No ${status.displayName.toLowerCase()} referrals',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(referralsByStatusProvider(status));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: referrals.length,
            itemBuilder: (context, index) {
              return ReferralCard(referral: referrals[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const EmptyState(
        icon: Icons.error,
        message: 'Error loading referrals',
      ),
    );
  }
}
