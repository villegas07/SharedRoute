import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/response_helpers.dart';
import '../../domain/entities/create_ticket_params.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../models/support_ticket_model.dart';

abstract class SupportRemoteDataSource {
  Future<void> createTicket(CreateTicketParams params);
  Future<List<SupportTicketModel>> getMyTickets();
  Future<SupportTicketModel> getTicketById(String id);
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final Dio _dio;

  const SupportRemoteDataSourceImpl(this._dio);

  @override
  Future<void> createTicket(CreateTicketParams params) async {
    try {
      await _dio.post('/support/tickets', data: {
        'subject': params.subject,
        'description': params.description,
        'category': const {
          TicketCategory.payment: 'PAYMENT',
          TicketCategory.trip: 'TRIP',
          TicketCategory.account: 'ACCOUNT',
          TicketCategory.other: 'OTHER',
        }[params.category] ?? 'OTHER',
      });
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<List<SupportTicketModel>> getMyTickets() async {
    try {
      final response = await _dio.get('/support/tickets');
      final list = extractList(response.data);
      return list
          .map((e) => SupportTicketModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<SupportTicketModel> getTicketById(String id) async {
    try {
      final response = await _dio.get('/support/tickets/$id');
      return SupportTicketModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException('Sin conexión a internet');
    }
    if (e.response?.statusCode == 404) {
      return const ServerException('Ticket no encontrado');
    }
    return const ServerException('Error de servidor');
  }
}
