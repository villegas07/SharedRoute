import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/create_review_params.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<void> createReview(CreateReviewParams params);
  Future<RatingSummaryModel> getUserReviews(String userId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final Dio _dio;

  const ReviewRemoteDataSourceImpl(this._dio);

  @override
  Future<void> createReview(CreateReviewParams params) async {
    try {
      await _dio.post(
        '/reviews/trips/${params.tripId}/driver',
        data: {
          'driverId': params.driverId,
          'rating': params.rating,
          if (params.comment != null) 'comment': params.comment,
        },
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<RatingSummaryModel> getUserReviews(String userId) async {
    try {
      final response = await _dio.get('/reviews/users/$userId');
      return RatingSummaryModel.fromJson(
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
    if (e.response?.statusCode == 409) {
      return const ServerException('Ya calificaste este viaje');
    }
    if (e.response?.statusCode == 404) {
      return const ServerException('Recurso no encontrado');
    }
    return const ServerException('Error de servidor');
  }
}
