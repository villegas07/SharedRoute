import '../../../../core/utils/typedef.dart';
import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.tripId,
    required super.passengerId,
    required super.seatsReserved,
    required super.totalPrice,
    required super.status,
    required super.createdAt,
  });

  factory BookingModel.fromJson(DataMap json) => BookingModel(
        id: (json['id'] as String?) ?? '',
        tripId: (json['tripId'] as String?) ?? '',
        passengerId: (json['passengerId'] as String?) ?? '',
        seatsReserved: (json['seatsReserved'] as num?)?.toInt() ?? 0,
        totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
        status: _parseStatus((json['status'] as String?) ?? ''),
        createdAt: (json['createdAt'] as String?) ?? '',
      );

  static BookingStatus _parseStatus(String value) {
    const map = {
      'PENDING': BookingStatus.pending,
      'CONFIRMED': BookingStatus.confirmed,
      'CANCELLED_BY_PASSENGER': BookingStatus.cancelledByPassenger,
      'CANCELLED_BY_DRIVER': BookingStatus.cancelledByDriver,
      'COMPLETED': BookingStatus.completed,
    };
    return map[value.toUpperCase()] ?? BookingStatus.pending;
  }
}
