import '../../../../core/utils/typedef.dart';
import '../entities/trip_history_entry.dart';
import '../entities/trip_history_params.dart';
import '../repositories/trip_history_repository.dart';

class GetTripHistoryUseCase {
  final TripHistoryRepository _repository;

  const GetTripHistoryUseCase(this._repository);

  ResultFuture<List<TripHistoryEntry>> call(TripHistoryParams params) =>
      _repository.getHistory(params);
}
