import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthUseCase _checkAuthUseCase;

  AuthViewModel(this._loginUseCase, this._logoutUseCase, this._checkAuthUseCase);

  AuthStatus _status = AuthStatus.initial;
  UserEntity? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserEntity? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> checkAuth() async {
    final isValid = await _checkAuthUseCase();
    _setStatus(isValid ? AuthStatus.authenticated : AuthStatus.unauthenticated);
  }

  Future<void> login(String email, String password) async {
    _setStatus(AuthStatus.loading);
    final result = await _loginUseCase(email, password);
    result.fold(_handleFailure, _handleSuccess);
  }

  Future<void> logout() async {
    _setStatus(AuthStatus.loading);
    final result = await _logoutUseCase();
    result.fold(
      _handleFailure,
      (_) {
        _currentUser = null;
        _setStatus(AuthStatus.unauthenticated);
      },
    );
  }

  void invalidateSession() {
    _currentUser = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  void _handleSuccess(UserEntity user) {
    _currentUser = user;
    _errorMessage = null;
    _setStatus(AuthStatus.authenticated);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(AuthStatus.error);
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }
}
