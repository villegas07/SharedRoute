import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/register_params.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/register_usecase.dart';

enum RegisterStatus { initial, loading, success, error }

class RegisterViewModel extends ChangeNotifier {
  final RegisterUseCase _registerUseCase;

  RegisterViewModel(this._registerUseCase);

  RegisterStatus _status = RegisterStatus.initial;
  UserEntity? _registeredUser;
  String? _errorMessage;

  RegisterStatus get status => _status;
  UserEntity? get registeredUser => _registeredUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == RegisterStatus.loading;

  Future<void> register(RegisterParams params) async {
    _setStatus(RegisterStatus.loading);
    final result = await _registerUseCase(params);
    result.fold(_handleFailure, _handleSuccess);
  }

  void _handleSuccess(UserEntity user) {
    _registeredUser = user;
    _errorMessage = null;
    _setStatus(RegisterStatus.success);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(RegisterStatus.error);
  }

  void _setStatus(RegisterStatus status) {
    _status = status;
    notifyListeners();
  }
}
