import '../../../../core/utils/typedef.dart';
import '../entities/register_params.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  ResultFuture<UserEntity> login(String email, String password);
  ResultFuture<UserEntity> register(RegisterParams params);
  ResultVoid logout();
  ResultVoid forgotPassword(String email);
}
