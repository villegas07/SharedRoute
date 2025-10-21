class User {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final double rating;
  final bool isDriver;
  final int trips;
  final int reviews;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.rating,
    required this.isDriver,
    required this.trips,
    required this.reviews,
  });

  @override
  String toString() => 'User(name: $name, email: $email, rating: $rating)';
}
