import 'package:equatable/equatable.dart';

enum UserRole { passenger, driver, admin }

enum UserStatus { active, inactive, suspended, pendingVerification }

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final UserStatus status;
  final String? profilePhotoUrl;
  final double averageRating;
  final String createdAt;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    this.profilePhotoUrl,
    required this.averageRating,
    required this.createdAt,
  });

  String get displayName => fullName.isNotEmpty ? fullName : '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        fullName,
        email,
        phone,
        role,
        status,
        profilePhotoUrl,
        averageRating,
        createdAt,
      ];
}
