import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  const BookingRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<BookingEntity> createBooking(String tripId, int seats) async {
    try {
      final booking = await _remoteDataSource.createBooking(tripId, seats);
      return Right(booking);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al crear la reserva'));
    }
  }

  @override
  ResultFuture<List<BookingEntity>> getMyBookings() async {
    try {
      final bookings = await _remoteDataSource.getMyBookings();
      return Right(bookings);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cargar reservas'));
    }
  }

  @override
  ResultFuture<BookingEntity> getBookingById(String id) async {
    try {
      final booking = await _remoteDataSource.getBookingById(id);
      return Right(booking);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cargar la reserva'));
    }
  }

  @override
  ResultFuture<BookingEntity> cancelBooking(String id) async {
    try {
      final booking = await _remoteDataSource.cancelBooking(id);
      return Right(booking);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cancelar la reserva'));
    }
  }
}
