import '../../../../core/utils/typedef.dart';
import '../entities/support_ticket_entity.dart';
import '../repositories/support_repository.dart';

class GetMyTicketsUseCase {
  final SupportRepository _repository;

  const GetMyTicketsUseCase(this._repository);

  ResultFuture<List<SupportTicketEntity>> call() =>
      _repository.getMyTickets();
}
