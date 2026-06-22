import '../../../../core/utils/typedef.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  ResultFuture<UserEntity> call(String email, String password) =>
      _repository.login(email, password);
}
