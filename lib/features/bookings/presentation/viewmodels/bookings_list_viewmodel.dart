import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';

enum BookingsListStatus { initial, loading, loaded, empty, error }

class BookingsListViewModel extends ChangeNotifier {
  final GetMyBookingsUseCase _getMyBookingsUseCase;
  final CancelBookingUseCase _cancelBookingUseCase;

  BookingsListViewModel(this._getMyBookingsUseCase, this._cancelBookingUseCase);

  BookingsListStatus _status = BookingsListStatus.initial;
  List<BookingEntity> _bookings = [];
  String? _errorMessage;

  BookingsListStatus get status => _status;
  List<BookingEntity> get bookings => _bookings;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == BookingsListStatus.loading;

  Future<void> loadBookings() async {
    _setStatus(BookingsListStatus.loading);
    final result = await _getMyBookingsUseCase();
    result.fold(_handleFailure, _handleSuccess);
  }

  Future<void> cancelBooking(String id) async {
    final result = await _cancelBookingUseCase(id);
    result.fold(
      _handleFailure,
      (_) => loadBookings(),
    );
  }

  void _handleSuccess(List<BookingEntity> bookings) {
    _bookings = bookings;
    _errorMessage = null;
    _setStatus(
        bookings.isEmpty ? BookingsListStatus.empty : BookingsListStatus.loaded);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(BookingsListStatus.error);
  }

  void _setStatus(BookingsListStatus s) {
    _status = s;
    notifyListeners();
  }
}
