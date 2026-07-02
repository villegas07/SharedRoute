import '../../../../core/utils/typedef.dart';
import '../entities/register_params.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  ResultFuture<UserEntity> call(RegisterParams params) =>
      _repository.register(params);
}
