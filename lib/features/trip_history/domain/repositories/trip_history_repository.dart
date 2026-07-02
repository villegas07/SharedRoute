import '../../../../core/utils/typedef.dart';
import '../entities/trip_history_entry.dart';
import '../entities/trip_history_params.dart';

abstract class TripHistoryRepository {
  ResultFuture<List<TripHistoryEntry>> getHistory(TripHistoryParams params);
  ResultFuture<TripHistoryEntry> getHistoryDetail(String tripId);
}
