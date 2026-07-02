import '../../../../core/utils/typedef.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  ResultVoid call() => _repository.logout();
}
