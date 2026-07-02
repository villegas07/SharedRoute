import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../auth/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getMyProfile();
  Future<UserModel> updateProfile(String id, Map<String, dynamic> data);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;

  const UserRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> getMyProfile() async {
    try {
      final response = await _dio.get('/users/me');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<UserModel> updateProfile(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/users/$id', data: data);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException('Sin conexión a internet');
    }
    return const ServerException('Error de servidor');
  }
}
