import '../../../../core/utils/typedef.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetMyBookingsUseCase {
  final BookingRepository _repository;

  const GetMyBookingsUseCase(this._repository);

  ResultFuture<List<BookingEntity>> call() => _repository.getMyBookings();
}
