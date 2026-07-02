import 'package:equatable/equatable.dart';

class PlacePredictionEntity extends Equatable {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  const PlacePredictionEntity({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  @override
  List<Object> get props => [placeId, description];
}
