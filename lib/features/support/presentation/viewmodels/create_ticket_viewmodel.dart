import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/create_ticket_params.dart';
import '../../domain/usecases/create_ticket_usecase.dart';

enum CreateTicketStatus { initial, loading, success, error }

class CreateTicketViewModel extends ChangeNotifier {
  final CreateTicketUseCase _useCase;

  CreateTicketStatus _status = CreateTicketStatus.initial;
  String? _errorMessage;

  CreateTicketStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == CreateTicketStatus.loading;

  CreateTicketViewModel(this._useCase);

  Future<void> submit(CreateTicketParams params) async {
    _setStatus(CreateTicketStatus.loading);
    final result = await _useCase(params);
    result.fold(_handleFailure, (_) => _handleSuccess());
  }

  void _handleSuccess() {
    _errorMessage = null;
    _setStatus(CreateTicketStatus.success);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(CreateTicketStatus.error);
  }

  void _setStatus(CreateTicketStatus s) {
    _status = s;
    notifyListeners();
  }
}
