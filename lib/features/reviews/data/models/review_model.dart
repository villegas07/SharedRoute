import '../../domain/entities/rating_summary_entity.dart';
import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.tripId,
    required super.reviewerId,
    required super.revieweeId,
    required super.rating,
    super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: (json['id'] as String?) ?? '',
      tripId: (json['tripId'] as String?) ?? '',
      reviewerId: (json['reviewerId'] as String?) ?? '',
      revieweeId: (json['revieweeId'] as String?) ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String?,
      createdAt: (json['createdAt'] as String?) ?? '',
    );
  }
}

class RatingSummaryModel extends RatingSummaryEntity {
  const RatingSummaryModel({
    required super.userId,
    required super.averageRating,
    required super.totalReviews,
    required super.breakdown,
  });

  factory RatingSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawBreakdown = json['breakdown'] as Map<String, dynamic>? ?? {};
    final breakdown = <int, int>{};
    rawBreakdown.forEach((key, value) {
      breakdown[int.parse(key)] = (value as num).toInt();
    });
    return RatingSummaryModel(
      userId: (json['userId'] as String?) ?? '',
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      breakdown: breakdown,
    );
  }
}
