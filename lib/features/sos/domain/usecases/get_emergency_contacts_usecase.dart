import '../../../../core/utils/typedef.dart';
import '../entities/emergency_contact_entity.dart';
import '../repositories/sos_repository.dart';

class GetEmergencyContactsUseCase {
  final SosRepository _repository;

  const GetEmergencyContactsUseCase(this._repository);

  ResultFuture<List<EmergencyContactEntity>> call() =>
      _repository.getEmergencyContacts();
}
