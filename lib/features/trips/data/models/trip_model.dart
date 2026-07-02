import '../../../../core/utils/typedef.dart';
import '../../domain/entities/trip_entity.dart';

class TripModel extends TripEntity {
  const TripModel({
    required super.id,
    required super.driverId,
    required super.vehicleId,
    required super.originAddress,
    required super.originCity,
    required super.originLatitude,
    required super.originLongitude,
    required super.destinationAddress,
    required super.destinationCity,
    required super.destinationLatitude,
    required super.destinationLongitude,
    required super.departureAt,
    required super.availableSeats,
    required super.pricePerSeat,
    required super.status,
    super.notes,
    required super.createdAt,
  });

  factory TripModel.fromJson(DataMap json) => TripModel(
        id: (json['id'] as String?) ?? '',
        driverId: (json['driverId'] as String?) ?? '',
        vehicleId: json['vehicleId'] as String? ?? '',
        originAddress: (json['originAddress'] as String?) ?? '',
        originCity: (json['originCity'] as String?) ?? '',
        originLatitude: (json['originLatitude'] as num?)?.toDouble() ?? 0.0,
        originLongitude: (json['originLongitude'] as num?)?.toDouble() ?? 0.0,
        destinationAddress: (json['destinationAddress'] as String?) ?? '',
        destinationCity: (json['destinationCity'] as String?) ?? '',
        destinationLatitude:
            (json['destinationLatitude'] as num?)?.toDouble() ?? 0.0,
        destinationLongitude:
            (json['destinationLongitude'] as num?)?.toDouble() ?? 0.0,
        departureAt: (json['departureAt'] as String?) ?? '',
        availableSeats: (json['availableSeats'] as num?)?.toInt() ?? 0,
        pricePerSeat: (json['pricePerSeat'] as num?)?.toDouble() ?? 0.0,
        status: _parseStatus((json['status'] as String?) ?? ''),
        notes: json['notes'] as String?,
        createdAt: (json['createdAt'] as String?) ?? '',
      );

  static TripStatus _parseStatus(String value) {
    const map = {
      'DRAFT': TripStatus.draft,
      'PUBLISHED': TripStatus.published,
      'IN_PROGRESS': TripStatus.inProgress,
      'COMPLETED': TripStatus.completed,
      'CANCELLED': TripStatus.cancelled,
    };
    return map[value.toUpperCase()] ?? TripStatus.draft;
  }
}
