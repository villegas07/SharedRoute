import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/response_helpers.dart';
import '../models/trip_model.dart';
import '../../domain/entities/trip_search_params.dart';

abstract class TripRemoteDataSource {
  Future<List<TripModel>> searchTrips(TripSearchParams params);
  Future<TripModel> getTripById(String id);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final Dio _dio;

  const TripRemoteDataSourceImpl(this._dio);

  @override
  Future<List<TripModel>> searchTrips(TripSearchParams params) async {
    try {
      final response = await _dio.get(
        '/trips',
        queryParameters: params.toQueryParams(),
      );
      final list = extractList(response.data);
      return list
          .map((e) => TripModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<TripModel> getTripById(String id) async {
    try {
      final response = await _dio.get('/trips/$id');
      return TripModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException('Sin conexión a internet');
    }
    if (e.response?.statusCode == 404) {
      return const ServerException('Viaje no encontrado');
    }
    return const ServerException('Error de servidor');
  }
}
