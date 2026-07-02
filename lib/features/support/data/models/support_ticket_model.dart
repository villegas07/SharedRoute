import '../../domain/entities/support_ticket_entity.dart';

class SupportTicketModel extends SupportTicketEntity {
  const SupportTicketModel({
    required super.id,
    required super.userId,
    required super.subject,
    required super.description,
    required super.status,
    required super.category,
    required super.createdAt,
    super.response,
    super.updatedAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: (json['id'] as String?) ?? '',
      userId: (json['userId'] as String?) ?? '',
      subject: (json['subject'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      status: const {
            'OPEN': TicketStatus.open,
            'IN_PROGRESS': TicketStatus.inProgress,
            'RESOLVED': TicketStatus.resolved,
            'CLOSED': TicketStatus.closed,
          }[(json['status'] as String?)?.toUpperCase()] ??
          TicketStatus.open,
      category: const {
            'PAYMENT': TicketCategory.payment,
            'TRIP': TicketCategory.trip,
            'ACCOUNT': TicketCategory.account,
            'OTHER': TicketCategory.other,
          }[(json['category'] as String?)?.toUpperCase()] ??
          TicketCategory.other,
      createdAt: (json['createdAt'] as String?) ?? '',
      response: json['response'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
