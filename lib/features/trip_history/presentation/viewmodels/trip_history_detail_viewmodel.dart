import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/trip_history_entry.dart';
import '../../domain/usecases/get_trip_history_detail_usecase.dart';

enum TripHistoryDetailStatus { initial, loading, loaded, error }

class TripHistoryDetailViewModel extends ChangeNotifier {
  final GetTripHistoryDetailUseCase _useCase;

  TripHistoryDetailStatus _status = TripHistoryDetailStatus.initial;
  TripHistoryEntry? _entry;
  String? _errorMessage;

  TripHistoryDetailStatus get status => _status;
  TripHistoryEntry? get entry => _entry;
  String? get errorMessage => _errorMessage;

  TripHistoryDetailViewModel(this._useCase);

  Future<void> loadDetail(String tripId) async {
    _setStatus(TripHistoryDetailStatus.loading);
    final result = await _useCase(tripId);
    result.fold(_handleFailure, _handleSuccess);
  }

  void _handleSuccess(TripHistoryEntry data) {
    _entry = data;
    _errorMessage = null;
    _setStatus(TripHistoryDetailStatus.loaded);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(TripHistoryDetailStatus.error);
  }

  void _setStatus(TripHistoryDetailStatus s) {
    _status = s;
    notifyListeners();
  }
}
