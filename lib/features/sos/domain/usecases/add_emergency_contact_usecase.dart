import '../../../../core/utils/typedef.dart';
import '../entities/add_contact_params.dart';
import '../repositories/sos_repository.dart';

class AddEmergencyContactUseCase {
  final SosRepository _repository;

  const AddEmergencyContactUseCase(this._repository);

  ResultVoid call(AddContactParams params) =>
      _repository.addEmergencyContact(params);
}
