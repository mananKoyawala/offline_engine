import 'dart:developer';

import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('# ==========================');
    log('# REQUEST URL  : ${options.method} ${options.uri}');
    log('# REQUEST BODY : ${options.data}');
    log('# ==========================');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('# ==========================');
    log(
      '# RESPONSE URL  : ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    log('# STATUS CODE   : ${response.statusCode}');
    log('# RESPONSE BODY : ${response.data}');
    log('# ==========================');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('# ==========================');
    log(
      '# ERROR URL     : ${err.requestOptions.method} ${err.requestOptions.uri}',
    );
    log('# STATUS CODE   : ${err.response?.statusCode}');
    log('# ERROR TYPE    : ${err.type}');
    log('# ERROR MESSAGE : ${err.message}');
    log('# ERROR BODY    : ${err.response?.data}');
    log('# ==========================');

    super.onError(err, handler);
  }
}
