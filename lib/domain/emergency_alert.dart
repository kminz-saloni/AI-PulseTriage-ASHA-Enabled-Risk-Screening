class EmergencyAlert {
  final String id;
  final String patientId;
  final String patientName;
  final String emergencyType;
  final String description;
  final String priority;
  final DateTime createdDate;
  final bool isActive;
  final String? resolution;
  final DateTime? resolvedDate;

  const EmergencyAlert({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.emergencyType,
    required this.description,
    required this.priority,
    required this.createdDate,
    this.isActive = true,
    this.resolution,
    this.resolvedDate,
  });

  EmergencyAlert copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? emergencyType,
    String? description,
    String? priority,
    DateTime? createdDate,
    bool? isActive,
    String? resolution,
    DateTime? resolvedDate,
  }) {
    return EmergencyAlert(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      emergencyType: emergencyType ?? this.emergencyType,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      createdDate: createdDate ?? this.createdDate,
      isActive: isActive ?? this.isActive,
      resolution: resolution ?? this.resolution,
      resolvedDate: resolvedDate ?? this.resolvedDate,
    );
  }
}
