abstract final class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String searchTrips = '/search';
  static const String tripDetail = '/trip/:id';
  static const String myBookings = '/bookings';
  static const String bookingDetail = '/booking/:id';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String tripHistory = '/history';
  static const String tripHistoryDetail = '/history/:tripId';
  static const String createReview = '/reviews/create/:tripId';
  static const String userReviews = '/reviews/user/:userId';
  static const String sos = '/sos';
  static const String addEmergencyContact = '/sos/add-contact';
  static const String supportTickets = '/support';
  static const String supportTicketDetail = '/support/:id';
  static const String createSupportTicket = '/support/create';
}
