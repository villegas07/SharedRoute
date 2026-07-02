import 'package:equatable/equatable.dart';

class GeocodedAddressEntity extends Equatable {
  final String formattedAddress;
  final String city;
  final String? department;
  final String? country;
  final double latitude;
  final double longitude;
  final String? placeId;

  const GeocodedAddressEntity({
    required this.formattedAddress,
    required this.city,
    this.department,
    this.country,
    required this.latitude,
    required this.longitude,
    this.placeId,
  });

  @override
  List<Object?> get props => [formattedAddress, latitude, longitude];
}
