import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/create_booking_usecase.dart';

enum BookingCreateStatus { initial, loading, success, error }

class BookingViewModel extends ChangeNotifier {
  final CreateBookingUseCase _createBookingUseCase;

  BookingViewModel(this._createBookingUseCase);

  BookingCreateStatus _status = BookingCreateStatus.initial;
  BookingEntity? _booking;
  String? _errorMessage;
  int _seatsSelected = 1;

  BookingCreateStatus get status => _status;
  BookingEntity? get booking => _booking;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == BookingCreateStatus.loading;
  int get seatsSelected => _seatsSelected;

  void setSeats(int seats) {
    _seatsSelected = seats;
    notifyListeners();
  }

  Future<void> createBooking(String tripId) async {
    _setStatus(BookingCreateStatus.loading);
    final result = await _createBookingUseCase(tripId, _seatsSelected);
    result.fold(_handleFailure, _handleSuccess);
  }

  void _handleSuccess(BookingEntity booking) {
    _booking = booking;
    _errorMessage = null;
    _setStatus(BookingCreateStatus.success);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(BookingCreateStatus.error);
  }

  void _setStatus(BookingCreateStatus s) {
    _status = s;
    notifyListeners();
  }
}
