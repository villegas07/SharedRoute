import '../../../../core/utils/typedef.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  ResultFuture<UserEntity> getMyProfile();
  ResultFuture<UserEntity> updateProfile(String id, Map<String, dynamic> data);
}
