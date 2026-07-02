import '../../domain/entities/emergency_contact_entity.dart';

class EmergencyContactModel extends EmergencyContactEntity {
  const EmergencyContactModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.phone,
    required super.relationship,
    required super.createdAt,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      id: (json['id'] as String?) ?? '',
      userId: (json['userId'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      relationship: (json['relationship'] as String?) ?? '',
      createdAt: (json['createdAt'] as String?) ?? '',
    );
  }
}
