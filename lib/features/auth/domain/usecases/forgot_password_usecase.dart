import '../../../../core/utils/typedef.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  ResultVoid call(String email) => _repository.forgotPassword(email);
}
