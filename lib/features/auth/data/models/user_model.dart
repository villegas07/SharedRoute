import '../../../../core/utils/typedef.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.role,
    required super.status,
    super.profilePhotoUrl,
    required super.averageRating,
    required super.createdAt,
  });

  factory UserModel.fromJson(DataMap json) => UserModel(
        id: (json['id'] as String?) ?? '',
        firstName: (json['firstName'] as String?) ?? '',
        lastName: (json['lastName'] as String?) ?? '',
        fullName: json['fullName'] as String? ??
            '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}',
        email: (json['email'] as String?) ?? '',
        phone: json['phone'] as String? ?? '',
        role: _parseRole((json['role'] as String?) ?? ''),
        status: _parseStatus((json['status'] as String?) ?? ''),
        profilePhotoUrl: json['profilePhotoUrl'] as String?,
        averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
        createdAt: (json['createdAt'] as String?) ?? '',
      );

  DataMap toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
      };

  static UserRole _parseRole(String value) =>
      UserRole.values.firstWhere(
        (e) => e.name.toUpperCase() == value.toUpperCase(),
        orElse: () => UserRole.passenger,
      );

  static UserStatus _parseStatus(String value) {
    const map = {
      'ACTIVE': UserStatus.active,
      'INACTIVE': UserStatus.inactive,
      'SUSPENDED': UserStatus.suspended,
      'PENDING_VERIFICATION': UserStatus.pendingVerification,
    };
    return map[value.toUpperCase()] ?? UserStatus.active;
  }
}
