import '../../../../core/utils/typedef.dart';
import '../entities/booking_entity.dart';

abstract class BookingRepository {
  ResultFuture<BookingEntity> createBooking(String tripId, int seatsReserved);
  ResultFuture<List<BookingEntity>> getMyBookings();
  ResultFuture<BookingEntity> getBookingById(String id);
  ResultFuture<BookingEntity> cancelBooking(String id);
}
