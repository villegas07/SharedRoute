import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/forgot_password_usecase.dart';

enum ForgotPasswordStatus { initial, loading, sent, error }

class ForgotPasswordViewModel extends ChangeNotifier {
  final ForgotPasswordUseCase _useCase;

  ForgotPasswordViewModel(this._useCase);

  ForgotPasswordStatus _status = ForgotPasswordStatus.initial;
  String? _errorMessage;

  ForgotPasswordStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ForgotPasswordStatus.loading;
  bool get emailSent => _status == ForgotPasswordStatus.sent;

  Future<void> sendResetEmail(String email) async {
    _setStatus(ForgotPasswordStatus.loading);
    final result = await _useCase(email);
    result.fold(_handleFailure, (_) => _setStatus(ForgotPasswordStatus.sent));
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(ForgotPasswordStatus.error);
  }

  void _setStatus(ForgotPasswordStatus status) {
    _status = status;
    notifyListeners();
  }
}
