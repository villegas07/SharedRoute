import '../../../../core/utils/typedef.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository _repository;

  const CreateBookingUseCase(this._repository);

  ResultFuture<BookingEntity> call(String tripId, int seats) =>
      _repository.createBooking(tripId, seats);
}
