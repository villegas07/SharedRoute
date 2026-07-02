import '../../../../core/services/token_service.dart';

class CheckAuthUseCase {
  final TokenService _tokenService;

  const CheckAuthUseCase(this._tokenService);

  Future<bool> call() => _tokenService.hasValidToken();
}
