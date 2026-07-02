import 'package:equatable/equatable.dart';

enum TicketStatus { open, inProgress, resolved, closed }

enum TicketCategory { payment, trip, account, other }

class SupportTicketEntity extends Equatable {
  final String id;
  final String userId;
  final String subject;
  final String description;
  final TicketStatus status;
  final TicketCategory category;
  final String createdAt;
  final String? response;
  final String? updatedAt;

  const SupportTicketEntity({
    required this.id,
    required this.userId,
    required this.subject,
    required this.description,
    required this.status,
    required this.category,
    required this.createdAt,
    this.response,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        subject,
        description,
        status,
        category,
        createdAt,
        response,
        updatedAt,
      ];
}
