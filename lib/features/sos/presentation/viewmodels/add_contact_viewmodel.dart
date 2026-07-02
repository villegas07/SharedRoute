import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/add_contact_params.dart';
import '../../domain/usecases/add_emergency_contact_usecase.dart';

enum AddContactStatus { initial, loading, success, error }

class AddContactViewModel extends ChangeNotifier {
  final AddEmergencyContactUseCase _useCase;

  AddContactStatus _status = AddContactStatus.initial;
  String? _errorMessage;

  AddContactStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AddContactStatus.loading;

  AddContactViewModel(this._useCase);

  Future<void> submit(AddContactParams params) async {
    _setStatus(AddContactStatus.loading);
    final result = await _useCase(params);
    result.fold(_handleFailure, (_) => _handleSuccess());
  }

  void _handleSuccess() {
    _errorMessage = null;
    _setStatus(AddContactStatus.success);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(AddContactStatus.error);
  }

  void _setStatus(AddContactStatus s) {
    _status = s;
    notifyListeners();
  }
}
