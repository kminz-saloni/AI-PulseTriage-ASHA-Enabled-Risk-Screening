enum RiskLevel { high, medium, low }

class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String village;
  final RiskLevel riskLevel;
  final String lastVisit;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.village,
    required this.riskLevel,
    required this.lastVisit,
  });
}

class Vital {
  final String systolic;
  final String diastolic;
  final String weight;
  final String temperature;

  Vital({
    required this.systolic,
    required this.diastolic,
    required this.weight,
    required this.temperature,
  });
}

class RiskResult {
  final RiskLevel level;
  final String explanation;
  final String action;
  final List<String> reasons;

  RiskResult({
    required this.level,
    required this.explanation,
    required this.action,
    required this.reasons,
  });
}
