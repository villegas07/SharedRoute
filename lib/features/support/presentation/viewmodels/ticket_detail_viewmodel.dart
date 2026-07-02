import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/usecases/get_ticket_detail_usecase.dart';

enum TicketDetailStatus { initial, loading, loaded, error }

class TicketDetailViewModel extends ChangeNotifier {
  final GetTicketDetailUseCase _useCase;

  TicketDetailStatus _status = TicketDetailStatus.initial;
  SupportTicketEntity? _ticket;
  String? _errorMessage;

  TicketDetailStatus get status => _status;
  SupportTicketEntity? get ticket => _ticket;
  String? get errorMessage => _errorMessage;

  TicketDetailViewModel(this._useCase);

  Future<void> loadTicket(String id) async {
    _setStatus(TicketDetailStatus.loading);
    final result = await _useCase(id);
    result.fold(_handleFailure, _handleSuccess);
  }

  void _handleSuccess(SupportTicketEntity data) {
    _ticket = data;
    _errorMessage = null;
    _setStatus(TicketDetailStatus.loaded);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(TicketDetailStatus.error);
  }

  void _setStatus(TicketDetailStatus s) {
    _status = s;
    notifyListeners();
  }
}
