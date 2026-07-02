import '../../../../core/utils/typedef.dart';
import '../entities/add_contact_params.dart';
import '../entities/emergency_contact_entity.dart';

abstract class SosRepository {
  ResultVoid addEmergencyContact(AddContactParams params);
  ResultFuture<List<EmergencyContactEntity>> getEmergencyContacts();
  ResultVoid deleteEmergencyContact(String id);
  ResultVoid triggerAlert();
}
