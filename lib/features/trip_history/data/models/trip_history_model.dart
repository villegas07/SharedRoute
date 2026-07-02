import '../../domain/entities/trip_history_entry.dart';

class TripHistoryModel extends TripHistoryEntry {
  const TripHistoryModel({
    required super.id,
    required super.tripId,
    required super.userId,
    required super.role,
    required super.originCity,
    required super.destinationCity,
    required super.departureAt,
    required super.status,
    required super.totalPrice,
    required super.createdAt,
  });

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) {
    return TripHistoryModel(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      userId: json['userId'] as String,
      role: HistoryRole.values.byName(json['role'] as String),
      originCity: json['originCity'] as String,
      destinationCity: json['destinationCity'] as String,
      departureAt: json['departureAt'] as String,
      status: json['status'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
    );
  }
}
