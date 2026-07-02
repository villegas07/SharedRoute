import '../../../../core/utils/typedef.dart';
import '../repositories/sos_repository.dart';

class DeleteEmergencyContactUseCase {
  final SosRepository _repository;

  const DeleteEmergencyContactUseCase(this._repository);

  ResultVoid call(String id) => _repository.deleteEmergencyContact(id);
}
