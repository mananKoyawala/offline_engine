import 'dart:developer';
import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('# ======================================');
    log('# REQUEST URL : ${options.uri}');
    log('# REQUEST BODY : ${options.data}');
    log('# REQUEST METHOD : ${options.method}');
    log('# ======================================');

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log('# ======================================');
    log('# RESPONSE STATUS CODE : ${response.statusCode}');
    log('# RESPONSE BODY : ${response.data}');
    log('# ======================================');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
