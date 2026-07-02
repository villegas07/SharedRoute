import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/geocoded_address_entity.dart';
import '../../domain/entities/place_prediction_entity.dart';
import '../../domain/repositories/geolocation_repository.dart';
import '../datasources/geolocation_remote_datasource.dart';

class GeolocationRepositoryImpl implements GeolocationRepository {
  final GeolocationRemoteDataSource _remoteDataSource;

  const GeolocationRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<PlacePredictionEntity>> searchPlaces(String query) async {
    try {
      final predictions = await _remoteDataSource.searchPlaces(query);
      return Right(predictions);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al buscar lugares'));
    }
  }

  @override
  ResultFuture<GeocodedAddressEntity> getPlaceDetails(String placeId) async {
    try {
      final address = await _remoteDataSource.getPlaceDetails(placeId);
      return Right(address);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al obtener detalles del lugar'));
    }
  }
}
