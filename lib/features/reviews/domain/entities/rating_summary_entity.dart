import 'package:equatable/equatable.dart';

class RatingSummaryEntity extends Equatable {
  final String userId;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> breakdown;

  const RatingSummaryEntity({
    required this.userId,
    required this.averageRating,
    required this.totalReviews,
    required this.breakdown,
  });

  @override
  List<Object> get props => [userId, averageRating, totalReviews, breakdown];
}
