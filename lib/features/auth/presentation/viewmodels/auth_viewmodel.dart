import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';

enum AuthStatus { initial, loading, authenticated, error }

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;

  AuthViewModel(this._loginUseCase);

  AuthStatus _status = AuthStatus.initial;
  UserEntity? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserEntity? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> login(String email, String password) async {
    _setStatus(AuthStatus.loading);
    final result = await _loginUseCase(email, password);
    result.fold(_handleFailure, _handleSuccess);
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
