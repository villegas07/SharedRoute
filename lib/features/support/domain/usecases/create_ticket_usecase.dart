import '../../../../core/utils/typedef.dart';
import '../entities/create_ticket_params.dart';
import '../repositories/support_repository.dart';

class CreateTicketUseCase {
  final SupportRepository _repository;

  const CreateTicketUseCase(this._repository);

  ResultVoid call(CreateTicketParams params) =>
      _repository.createTicket(params);
}
