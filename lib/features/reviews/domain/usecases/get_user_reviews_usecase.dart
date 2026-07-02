import '../../../../core/utils/typedef.dart';
import '../entities/rating_summary_entity.dart';
import '../repositories/review_repository.dart';

class GetUserReviewsUseCase {
  final ReviewRepository _repository;

  const GetUserReviewsUseCase(this._repository);

  ResultFuture<RatingSummaryEntity> call(String userId) =>
      _repository.getUserReviews(userId);
}
