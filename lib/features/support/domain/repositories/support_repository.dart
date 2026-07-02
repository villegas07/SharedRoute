import '../../../../core/utils/typedef.dart';
import '../entities/create_ticket_params.dart';
import '../entities/support_ticket_entity.dart';

abstract class SupportRepository {
  ResultVoid createTicket(CreateTicketParams params);
  ResultFuture<List<SupportTicketEntity>> getMyTickets();
  ResultFuture<SupportTicketEntity> getTicketById(String id);
}
