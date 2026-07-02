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
      status: TicketStatus.values.firstWhere(
        (e) =>
            e.name.toUpperCase() ==
            (json['status'] as String?)?.toUpperCase(),
        orElse: () => TicketStatus.open,
      ),
      category: TicketCategory.values.firstWhere(
        (e) =>
            e.name.toUpperCase() ==
            (json['category'] as String?)?.toUpperCase(),
        orElse: () => TicketCategory.other,
      ),
      createdAt: (json['createdAt'] as String?) ?? '',
      response: json['response'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
