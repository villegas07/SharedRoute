import '../../../../core/utils/typedef.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CancelBookingUseCase {
  final BookingRepository _repository;

  const CancelBookingUseCase(this._repository);

  ResultFuture<BookingEntity> call(String id) => _repository.cancelBooking(id);
}
