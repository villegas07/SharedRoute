import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/usecases/get_trip_detail_usecase.dart';

enum TripDetailStatus { initial, loading, loaded, error }

class TripDetailViewModel extends ChangeNotifier {
  final GetTripDetailUseCase _getTripDetailUseCase;

  TripDetailViewModel(this._getTripDetailUseCase);

  TripDetailStatus _status = TripDetailStatus.initial;
  TripEntity? _trip;
  String? _errorMessage;

  TripDetailStatus get status => _status;
  TripEntity? get trip => _trip;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == TripDetailStatus.loading;

  Future<void> loadTrip(String id) async {
    _setStatus(TripDetailStatus.loading);
    final result = await _getTripDetailUseCase(id);
    result.fold(_handleFailure, _handleSuccess);
  }

  void _handleSuccess(TripEntity trip) {
    _trip = trip;
    _errorMessage = null;
    _setStatus(TripDetailStatus.loaded);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(TripDetailStatus.error);
  }

  void _setStatus(TripDetailStatus status) {
    _status = status;
    notifyListeners();
  }
}
