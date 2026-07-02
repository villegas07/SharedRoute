import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/trip_search_params.dart';
import '../../domain/usecases/search_trips_usecase.dart';

enum TripSearchStatus { initial, loading, loaded, empty, error }

class TripSearchViewModel extends ChangeNotifier {
  final SearchTripsUseCase _searchTripsUseCase;

  TripSearchViewModel(this._searchTripsUseCase);

  TripSearchStatus _status = TripSearchStatus.initial;
  List<TripEntity> _trips = [];
  String? _errorMessage;

  TripSearchStatus get status => _status;
  List<TripEntity> get trips => _trips;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == TripSearchStatus.loading;

  Future<void> search(TripSearchParams params) async {
    _setStatus(TripSearchStatus.loading);
    final result = await _searchTripsUseCase(params);
    result.fold(_handleFailure, _handleSuccess);
  }

  void clearResults() {
    _trips = [];
    _errorMessage = null;
    _setStatus(TripSearchStatus.initial);
  }

  void _handleSuccess(List<TripEntity> trips) {
    _trips = trips;
    _errorMessage = null;
    _setStatus(trips.isEmpty ? TripSearchStatus.empty : TripSearchStatus.loaded);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(TripSearchStatus.error);
  }

  void _setStatus(TripSearchStatus status) {
    _status = status;
    notifyListeners();
  }
}
