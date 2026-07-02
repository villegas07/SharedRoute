import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/trip_search_params.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_remote_datasource.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource _remoteDataSource;

  const TripRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<TripEntity>> searchTrips(TripSearchParams params) async {
    try {
      final trips = await _remoteDataSource.searchTrips(params);
      return Right(trips);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al buscar viajes'));
    }
  }

  @override
  ResultFuture<TripEntity> getTripById(String id) async {
    try {
      final trip = await _remoteDataSource.getTripById(id);
      return Right(trip);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cargar el viaje'));
    }
  }
}
