enum IncentiveStatus {
  eligible,
  pending,
  approved,
  paid,
}

extension IncentiveStatusExtension on IncentiveStatus {
  String get displayName {
    switch (this) {
      case IncentiveStatus.eligible:
        return 'Eligible';
      case IncentiveStatus.pending:
        return 'Pending';
      case IncentiveStatus.approved:
        return 'Approved';
      case IncentiveStatus.paid:
        return 'Paid';
    }
  }
}
