import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/response_helpers.dart';
import '../../domain/entities/add_contact_params.dart';
import '../models/emergency_contact_model.dart';

abstract class SosRemoteDataSource {
  Future<void> addEmergencyContact(AddContactParams params);
  Future<List<EmergencyContactModel>> getEmergencyContacts();
  Future<void> deleteEmergencyContact(String id);
  Future<void> triggerAlert();
}

class SosRemoteDataSourceImpl implements SosRemoteDataSource {
  final Dio _dio;

  const SosRemoteDataSourceImpl(this._dio);

  @override
  Future<void> addEmergencyContact(AddContactParams params) async {
    try {
      await _dio.post('/sos/emergency-contacts', data: {
        'name': params.name,
        'phone': params.phone,
        'relationship': params.relationship,
      });
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<List<EmergencyContactModel>> getEmergencyContacts() async {
    try {
      final response = await _dio.get('/sos/emergency-contacts');
      final list = extractList(response.data);
      return list
          .map((e) => EmergencyContactModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> deleteEmergencyContact(String id) async {
    try {
      await _dio.delete('/sos/emergency-contacts/$id');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> triggerAlert() async {
    try {
      await _dio.post('/sos/alerts');
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
      return const ServerException('Contacto no encontrado');
    }
    return const ServerException('Error de servidor');
  }
}
