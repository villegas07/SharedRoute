import '../../../../core/utils/typedef.dart';
import '../entities/place_prediction_entity.dart';
import '../repositories/geolocation_repository.dart';

class SearchPlacesUseCase {
  final GeolocationRepository _repository;

  const SearchPlacesUseCase(this._repository);

  ResultFuture<List<PlacePredictionEntity>> call(String query) =>
      _repository.searchPlaces(query);
}
