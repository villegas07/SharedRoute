import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../../domain/entities/register_params.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register(RegisterParams params);
  Future<void> logout(String refreshToken);
  Future<void> forgotPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  const AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterParams params) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'firstName': params.firstName,
        'lastName': params.lastName,
        'email': params.email,
        'phone': params.phone,
        'password': params.password,
      });
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post('/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException('Sin conexión a internet');
    }
    final status = e.response?.statusCode;
    if (status == 401) return const AuthException('Credenciales incorrectas');
    if (status == 409) return const AuthException('El correo ya está registrado');
    return const ServerException('Error de servidor');
  }
}
