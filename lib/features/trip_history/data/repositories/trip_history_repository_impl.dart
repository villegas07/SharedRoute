import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/trip_history_entry.dart';
import '../../domain/entities/trip_history_params.dart';
import '../../domain/repositories/trip_history_repository.dart';
import '../datasources/trip_history_remote_datasource.dart';

class TripHistoryRepositoryImpl implements TripHistoryRepository {
  final TripHistoryRemoteDataSource _remoteDataSource;

  const TripHistoryRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<TripHistoryEntry>> getHistory(
      TripHistoryParams params) async {
    try {
      final entries = await _remoteDataSource.getHistory(params);
      return Right(entries);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cargar el historial'));
    }
  }

  @override
  ResultFuture<TripHistoryEntry> getHistoryDetail(String tripId) async {
    try {
      final entry = await _remoteDataSource.getHistoryDetail(tripId);
      return Right(entry);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cargar el detalle'));
    }
  }
}
