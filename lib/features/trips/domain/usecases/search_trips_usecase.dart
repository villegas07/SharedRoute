import '../../../../core/utils/typedef.dart';
import '../entities/trip_entity.dart';
import '../entities/trip_search_params.dart';
import '../repositories/trip_repository.dart';

class SearchTripsUseCase {
  final TripRepository _repository;

  const SearchTripsUseCase(this._repository);

  ResultFuture<List<TripEntity>> call(TripSearchParams params) =>
      _repository.searchTrips(params);
}
