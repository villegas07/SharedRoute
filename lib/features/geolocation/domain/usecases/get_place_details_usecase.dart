import '../../../../core/utils/typedef.dart';
import '../entities/geocoded_address_entity.dart';
import '../repositories/geolocation_repository.dart';

class GetPlaceDetailsUseCase {
  final GeolocationRepository _repository;

  const GetPlaceDetailsUseCase(this._repository);

  ResultFuture<GeocodedAddressEntity> call(String placeId) =>
      _repository.getPlaceDetails(placeId);
}
