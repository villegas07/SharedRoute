import '../../../../core/utils/typedef.dart';
import '../../domain/entities/geocoded_address_entity.dart';
import '../../domain/entities/place_prediction_entity.dart';

class PlacePredictionModel extends PlacePredictionEntity {
  const PlacePredictionModel({
    required super.placeId,
    required super.description,
    required super.mainText,
    required super.secondaryText,
  });

  factory PlacePredictionModel.fromJson(DataMap json) => PlacePredictionModel(
        placeId: (json['placeId'] as String?) ?? '',
        description: (json['description'] as String?) ?? '',
        mainText: (json['mainText'] as String?) ?? '',
        secondaryText: (json['secondaryText'] as String?) ?? '',
      );
}

class GeocodedAddressModel extends GeocodedAddressEntity {
  const GeocodedAddressModel({
    required super.formattedAddress,
    required super.city,
    super.department,
    super.country,
    required super.latitude,
    required super.longitude,
    super.placeId,
  });

  factory GeocodedAddressModel.fromJson(DataMap json) => GeocodedAddressModel(
        formattedAddress: (json['formattedAddress'] as String?) ?? '',
        city: (json['city'] as String?) ?? '',
        department: json['department'] as String?,
        country: json['country'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
        placeId: json['placeId'] as String?,
      );
}
