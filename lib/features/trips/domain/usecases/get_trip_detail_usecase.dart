import '../../../../core/utils/typedef.dart';
import '../entities/trip_entity.dart';
import '../repositories/trip_repository.dart';

class GetTripDetailUseCase {
  final TripRepository _repository;

  const GetTripDetailUseCase(this._repository);

  ResultFuture<TripEntity> call(String id) => _repository.getTripById(id);
}
