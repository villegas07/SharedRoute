import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/usecases/get_my_tickets_usecase.dart';

enum TicketsListStatus { initial, loading, loaded, empty, error }

class TicketsListViewModel extends ChangeNotifier {
  final GetMyTicketsUseCase _useCase;

  TicketsListStatus _status = TicketsListStatus.initial;
  List<SupportTicketEntity> _tickets = [];
  String? _errorMessage;

  TicketsListStatus get status => _status;
  List<SupportTicketEntity> get tickets => _tickets;
  String? get errorMessage => _errorMessage;

  TicketsListViewModel(this._useCase);

  Future<void> loadTickets() async {
    _setStatus(TicketsListStatus.loading);
    final result = await _useCase();
    result.fold(_handleFailure, _handleSuccess);
  }

  void _handleSuccess(List<SupportTicketEntity> data) {
    _tickets = data;
    _errorMessage = null;
    _setStatus(data.isEmpty ? TicketsListStatus.empty : TicketsListStatus.loaded);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(TicketsListStatus.error);
  }

  void _setStatus(TicketsListStatus s) {
    _status = s;
    notifyListeners();
  }
}
