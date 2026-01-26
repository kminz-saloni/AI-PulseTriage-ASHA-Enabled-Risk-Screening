import 'risk_level.dart';

class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String address;
  final String phoneNumber;
  final RiskLevel? latestRiskLevel;
  final DateTime? lastVisitDate;
  final bool hasTbHistory;
  final bool hasDiabetes;
  final bool hasHypertension;

  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.address,
    required this.phoneNumber,
    this.latestRiskLevel,
    this.lastVisitDate,
    this.hasTbHistory = false,
    this.hasDiabetes = false,
    this.hasHypertension = false,
  });

  Patient copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? address,
    String? phoneNumber,
    RiskLevel? latestRiskLevel,
    DateTime? lastVisitDate,
    bool? hasTbHistory,
    bool? hasDiabetes,
    bool? hasHypertension,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      latestRiskLevel: latestRiskLevel ?? this.latestRiskLevel,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      hasTbHistory: hasTbHistory ?? this.hasTbHistory,
      hasDiabetes: hasDiabetes ?? this.hasDiabetes,
      hasHypertension: hasHypertension ?? this.hasHypertension,
    );
  }
}
