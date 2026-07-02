import '../../../../core/utils/typedef.dart';
import '../entities/trip_history_entry.dart';
import '../repositories/trip_history_repository.dart';

class GetTripHistoryDetailUseCase {
  final TripHistoryRepository _repository;

  const GetTripHistoryDetailUseCase(this._repository);

  ResultFuture<TripHistoryEntry> call(String tripId) =>
      _repository.getHistoryDetail(tripId);
}
