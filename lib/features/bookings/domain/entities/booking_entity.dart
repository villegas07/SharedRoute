import 'package:equatable/equatable.dart';

enum BookingStatus {
  pending,
  confirmed,
  cancelledByPassenger,
  cancelledByDriver,
  completed,
}

class BookingEntity extends Equatable {
  final String id;
  final String tripId;
  final String passengerId;
  final int seatsReserved;
  final double totalPrice;
  final BookingStatus status;
  final String createdAt;

  const BookingEntity({
    required this.id,
    required this.tripId,
    required this.passengerId,
    required this.seatsReserved,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object> get props =>
      [id, tripId, passengerId, seatsReserved, totalPrice, status, createdAt];
}
