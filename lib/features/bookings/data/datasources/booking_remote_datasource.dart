import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking(String tripId, int seatsReserved);
  Future<List<BookingModel>> getMyBookings();
  Future<BookingModel> getBookingById(String id);
  Future<BookingModel> cancelBooking(String id);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final Dio _dio;

  const BookingRemoteDataSourceImpl(this._dio);

  @override
  Future<BookingModel> createBooking(String tripId, int seatsReserved) async {
    try {
      final response = await _dio.post(
        '/bookings',
        data: {'tripId': tripId, 'seatsReserved': seatsReserved},
      );
      return BookingModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<List<BookingModel>> getMyBookings() async {
    try {
      final response = await _dio.get('/bookings/my');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<BookingModel> getBookingById(String id) async {
    try {
      final response = await _dio.get('/bookings/$id');
      return BookingModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<BookingModel> cancelBooking(String id) async {
    try {
      final response = await _dio.patch('/bookings/$id/cancel');
      return BookingModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException('Sin conexión a internet');
    }
    if (e.response?.statusCode == 409) {
      return const ServerException('Ya tienes una reserva en este viaje');
    }
    return const ServerException('Error de servidor');
  }
}
