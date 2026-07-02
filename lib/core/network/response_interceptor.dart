import 'package:dio/dio.dart';

/// Unwraps the API envelope `{ "data": ..., "success": true, "timestamp": ... }`
/// so every datasource receives the inner payload directly.
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body is Map<String, dynamic> && body.containsKey('data')) {
      response.data = body['data'];
    }
    handler.next(response);
  }
}
