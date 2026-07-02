import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/geolocation_models.dart';

abstract class GeolocationRemoteDataSource {
  Future<List<PlacePredictionModel>> searchPlaces(String query);
  Future<GeocodedAddressModel> getPlaceDetails(String placeId);
}

class GeolocationRemoteDataSourceImpl implements GeolocationRemoteDataSource {
  final Dio _dio;

  const GeolocationRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PlacePredictionModel>> searchPlaces(String query) async {
    try {
      final response = await _dio.get(
        '/geolocation/search-places',
        queryParameters: {'query': query},
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => PlacePredictionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<GeocodedAddressModel> getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        '/geolocation/place-details',
        queryParameters: {'placeId': placeId},
      );
      return GeocodedAddressModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException('Sin conexión a internet');
    }
    return const ServerException('Error de servidor');
  }
}
