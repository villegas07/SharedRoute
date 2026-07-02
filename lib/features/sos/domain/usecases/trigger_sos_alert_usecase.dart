import '../../../../core/utils/typedef.dart';
import '../repositories/sos_repository.dart';

class TriggerSosAlertUseCase {
  final SosRepository _repository;

  const TriggerSosAlertUseCase(this._repository);

  ResultVoid call() => _repository.triggerAlert();
}
