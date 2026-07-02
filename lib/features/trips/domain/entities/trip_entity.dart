import 'package:equatable/equatable.dart';

enum TripStatus { draft, published, inProgress, completed, cancelled }

class TripEntity extends Equatable {
  final String id;
  final String driverId;
  final String vehicleId;
  final String originAddress;
  final String originCity;
  final double originLatitude;
  final double originLongitude;
  final String destinationAddress;
  final String destinationCity;
  final double destinationLatitude;
  final double destinationLongitude;
  final String departureAt;
  final int availableSeats;
  final double pricePerSeat;
  final TripStatus status;
  final String? notes;
  final String createdAt;

  const TripEntity({
    required this.id,
    required this.driverId,
    required this.vehicleId,
    required this.originAddress,
    required this.originCity,
    required this.originLatitude,
    required this.originLongitude,
    required this.destinationAddress,
    required this.destinationCity,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.departureAt,
    required this.availableSeats,
    required this.pricePerSeat,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        driverId,
        vehicleId,
        originCity,
        destinationCity,
        departureAt,
        availableSeats,
        pricePerSeat,
        status,
      ];
}
