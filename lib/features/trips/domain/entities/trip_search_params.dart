import 'package:equatable/equatable.dart';

class TripSearchParams extends Equatable {
  final String? originCity;
  final String? destinationCity;
  final String? departureDate;
  final int? minSeats;

  const TripSearchParams({
    this.originCity,
    this.destinationCity,
    this.departureDate,
    this.minSeats,
  });

  bool get isEmpty =>
      originCity == null &&
      destinationCity == null &&
      departureDate == null &&
      minSeats == null;

  Map<String, dynamic> toQueryParams() => {
        if (originCity != null) 'originCity': originCity,
        if (destinationCity != null) 'destinationCity': destinationCity,
        if (departureDate != null) 'departureDate': departureDate,
        if (minSeats != null) 'minSeats': minSeats,
      };

  @override
  List<Object?> get props => [originCity, destinationCity, departureDate, minSeats];
}
