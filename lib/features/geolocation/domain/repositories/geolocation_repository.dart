import '../../../../core/utils/typedef.dart';
import '../entities/geocoded_address_entity.dart';
import '../entities/place_prediction_entity.dart';

abstract class GeolocationRepository {
  ResultFuture<List<PlacePredictionEntity>> searchPlaces(String query);
  ResultFuture<GeocodedAddressEntity> getPlaceDetails(String placeId);
}
