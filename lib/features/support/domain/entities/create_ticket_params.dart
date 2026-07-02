import 'package:equatable/equatable.dart';

import 'support_ticket_entity.dart';

class CreateTicketParams extends Equatable {
  final String subject;
  final String description;
  final TicketCategory category;

  const CreateTicketParams({
    required this.subject,
    required this.description,
    required this.category,
  });

  @override
  List<Object> get props => [subject, description, category];
}
