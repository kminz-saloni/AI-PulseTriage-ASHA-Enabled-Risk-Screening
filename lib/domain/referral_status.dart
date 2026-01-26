enum ReferralStatus {
  open,
  partial,
  completed,
  hospitalIssue,
  other,
}

extension ReferralStatusExtension on ReferralStatus {
  String get displayName {
    switch (this) {
      case ReferralStatus.open:
        return 'Open';
      case ReferralStatus.partial:
        return 'Partial';
      case ReferralStatus.completed:
        return 'Completed';
      case ReferralStatus.hospitalIssue:
        return 'Hospital Issue';
      case ReferralStatus.other:
        return 'Other';
    }
  }
}
