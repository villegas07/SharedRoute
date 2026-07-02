import 'package:equatable/equatable.dart';

class CreateReviewParams extends Equatable {
  final String tripId;
  final String driverId;
  final int rating;
  final String? comment;

  const CreateReviewParams({
    required this.tripId,
    required this.driverId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [tripId, driverId, rating, comment];
}
