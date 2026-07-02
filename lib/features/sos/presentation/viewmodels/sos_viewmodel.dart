import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/emergency_contact_entity.dart';
import '../../domain/usecases/delete_emergency_contact_usecase.dart';
import '../../domain/usecases/get_emergency_contacts_usecase.dart';
import '../../domain/usecases/trigger_sos_alert_usecase.dart';

enum SosStatus { initial, loading, loaded, empty, error }

enum AlertStatus { idle, sending, sent, error }

class SosViewModel extends ChangeNotifier {
  final GetEmergencyContactsUseCase _getContactsUseCase;
  final DeleteEmergencyContactUseCase _deleteContactUseCase;
  final TriggerSosAlertUseCase _triggerAlertUseCase;

  SosStatus _status = SosStatus.initial;
  AlertStatus _alertStatus = AlertStatus.idle;
  List<EmergencyContactEntity> _contacts = [];
  String? _errorMessage;

  SosStatus get status => _status;
  AlertStatus get alertStatus => _alertStatus;
  List<EmergencyContactEntity> get contacts => _contacts;
  String? get errorMessage => _errorMessage;

  SosViewModel(
    this._getContactsUseCase,
    this._deleteContactUseCase,
    this._triggerAlertUseCase,
  );

  Future<void> loadContacts() async {
    _setStatus(SosStatus.loading);
    final result = await _getContactsUseCase();
    result.fold(_handleContactsFailure, _handleContactsSuccess);
  }

  Future<void> deleteContact(String id) async {
    final result = await _deleteContactUseCase(id);
    result.fold(
      (f) => _errorMessage = f.message,
      (_) => _contacts.removeWhere((c) => c.id == id),
    );
    notifyListeners();
  }

  Future<void> triggerAlert() async {
    _alertStatus = AlertStatus.sending;
    notifyListeners();
    final result = await _triggerAlertUseCase();
    result.fold(
      (_) {
        _alertStatus = AlertStatus.error;
        notifyListeners();
      },
      (_) {
        _alertStatus = AlertStatus.sent;
        notifyListeners();
      },
    );
  }

  void resetAlertStatus() {
    _alertStatus = AlertStatus.idle;
    notifyListeners();
  }

  void _handleContactsSuccess(List<EmergencyContactEntity> data) {
    _contacts = data;
    _errorMessage = null;
    _setStatus(data.isEmpty ? SosStatus.empty : SosStatus.loaded);
  }

  void _handleContactsFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(SosStatus.error);
  }

  void _setStatus(SosStatus s) {
    _status = s;
    notifyListeners();
  }
}
