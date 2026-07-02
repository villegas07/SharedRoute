import 'package:equatable/equatable.dart';

class EmergencyContactEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String relationship;
  final String createdAt;

  const EmergencyContactEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.relationship,
    required this.createdAt,
  });

  @override
  List<Object> get props =>
      [id, userId, name, phone, relationship, createdAt];
}
