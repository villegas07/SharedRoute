import '../../../../core/utils/typedef.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
  });

  factory UserModel.fromJson(DataMap json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        photoUrl: json['photoUrl'] as String?,
      );

  DataMap toJson() => {
        'id': id,
        'name': name,
        'email': email,
        if (photoUrl != null) 'photoUrl': photoUrl,
      };
}
