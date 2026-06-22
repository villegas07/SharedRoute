import '../../../../core/utils/typedef.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  ResultFuture<UserEntity> login(String email, String password);
  ResultVoid logout();
}
