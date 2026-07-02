import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/create_review_params.dart';
import '../../domain/entities/rating_summary_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _remoteDataSource;

  const ReviewRepositoryImpl(this._remoteDataSource);

  @override
  ResultVoid createReview(CreateReviewParams params) async {
    try {
      await _remoteDataSource.createReview(params);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al enviar la reseña'));
    }
  }

  @override
  ResultFuture<RatingSummaryEntity> getUserReviews(String userId) async {
    try {
      final summary = await _remoteDataSource.getUserReviews(userId);
      return Right(summary);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cargar reseñas'));
    }
  }
}
