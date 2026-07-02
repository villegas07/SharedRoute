import '../../../../core/utils/typedef.dart';
import '../entities/support_ticket_entity.dart';
import '../repositories/support_repository.dart';

class GetTicketDetailUseCase {
  final SupportRepository _repository;

  const GetTicketDetailUseCase(this._repository);

  ResultFuture<SupportTicketEntity> call(String id) =>
      _repository.getTicketById(id);
}
