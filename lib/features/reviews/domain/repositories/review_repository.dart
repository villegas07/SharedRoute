import '../../../../core/utils/typedef.dart';
import '../entities/create_review_params.dart';
import '../entities/rating_summary_entity.dart';

abstract class ReviewRepository {
  ResultVoid createReview(CreateReviewParams params);
  ResultFuture<RatingSummaryEntity> getUserReviews(String userId);
}
