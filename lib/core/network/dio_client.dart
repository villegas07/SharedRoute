import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../services/token_service.dart';
import 'auth_interceptor.dart';
import 'response_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient(TokenService tokenService) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _addInterceptors(tokenService);
  }

  void _addInterceptors(TokenService tokenService) {
    dio.interceptors.add(ResponseInterceptor());
    dio.interceptors.add(AuthInterceptor(tokenService));
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(responseBody: true));
    }
  }
}
