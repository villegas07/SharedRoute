import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/response_helpers.dart';
import '../../domain/entities/trip_history_params.dart';
import '../models/trip_history_model.dart';

abstract class TripHistoryRemoteDataSource {
  Future<List<TripHistoryModel>> getHistory(TripHistoryParams params);
  Future<TripHistoryModel> getHistoryDetail(String tripId);
}

class TripHistoryRemoteDataSourceImpl implements TripHistoryRemoteDataSource {
  final Dio _dio;

  const TripHistoryRemoteDataSourceImpl(this._dio);

  @override
  Future<List<TripHistoryModel>> getHistory(TripHistoryParams params) async {
    try {
      final response = await _dio.get(
        '/trip-history',
        queryParameters: params.toQueryParams(),
      );
      final list = extractList(response.data);
      return list
          .map((e) => TripHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<TripHistoryModel> getHistoryDetail(String tripId) async {
    try {
      final response = await _dio.get('/trip-history/$tripId');
      return TripHistoryModel.fromJson(
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
    if (e.response?.statusCode == 404) {
      return const ServerException('Historial no encontrado');
    }
    return const ServerException('Error de servidor');
  }
}
