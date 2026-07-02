import '../../../../core/utils/typedef.dart';
import '../entities/trip_entity.dart';
import '../entities/trip_search_params.dart';

abstract class TripRepository {
  ResultFuture<List<TripEntity>> searchTrips(TripSearchParams params);
  ResultFuture<TripEntity> getTripById(String id);
}
