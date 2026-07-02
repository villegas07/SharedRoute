import 'package:equatable/equatable.dart';

enum HistoryRole { passenger, driver }

class TripHistoryEntry extends Equatable {
  final String id;
  final String tripId;
  final String userId;
  final HistoryRole role;
  final String originCity;
  final String destinationCity;
  final String departureAt;
  final String status;
  final double totalPrice;
  final String createdAt;

  const TripHistoryEntry({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.role,
    required this.originCity,
    required this.destinationCity,
    required this.departureAt,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        tripId,
        userId,
        role,
        originCity,
        destinationCity,
        departureAt,
        status,
        totalPrice,
        createdAt,
      ];
}
