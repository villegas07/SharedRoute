class Trip {
  final String id;
  final String driverId;
  final String driverName;
  final double driverRating;
  final String driverImage;
  final String vehicleInfo;
  final String origin;
  final String destination;
  final String departureTime;
  final String departureDate;
  final int availableSeats;
  final double price;
  final int offers;
  final bool isActive;

  Trip({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.driverRating,
    required this.driverImage,
    required this.vehicleInfo,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.departureDate,
    required this.availableSeats,
    required this.price,
    required this.offers,
    this.isActive = true,
  });

  @override
  String toString() =>
      'Trip(id: $id, driver: $driverName, origin: $origin, destination: $destination)';
}
