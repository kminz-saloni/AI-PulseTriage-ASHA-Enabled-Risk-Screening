enum RiskLevel {
  green,
  yellow,
  red,
}

extension RiskLevelExtension on RiskLevel {
  String get displayName {
    switch (this) {
      case RiskLevel.green:
        return 'Low Risk';
      case RiskLevel.yellow:
        return 'Medium Risk';
      case RiskLevel.red:
        return 'High Risk';
    }
  }
}
