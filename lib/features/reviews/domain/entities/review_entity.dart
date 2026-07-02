import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String tripId;
  final String reviewerId;
  final String revieweeId;
  final int rating;
  final String? comment;
  final String createdAt;

  const ReviewEntity({
    required this.id,
    required this.tripId,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, tripId, reviewerId, revieweeId, rating, comment, createdAt];
}
