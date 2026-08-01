import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:offline_engine/core/api_clients.dart';
import 'package:offline_engine/core/app_container.dart';
import 'package:offline_engine/feature/login/presentation/provider/login_provider.dart';

class AppInterceptor extends Interceptor {
  static const String _sessionRecoveryAttemptedKey =
      '__session_recovery_attempted__';

  final APIClients _clients;
  Future<bool>? _inFlightSessionRecovery;

  AppInterceptor({required APIClients clients}) : _clients = clients;

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

    if (response.statusCode == 498) {
      unawaited(_handleSessionExpiredResponse(response, handler));
      return;
    }

    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    log('# ==========================');
    log(
      '# ERROR URL     : ${err.requestOptions.method} ${err.requestOptions.uri}',
    );
    log('# STATUS CODE   : ${err.response?.statusCode}');
    log('# ERROR TYPE    : ${err.type}');
    log('# ERROR MESSAGE : ${err.message}');
    log('# ERROR BODY    : ${err.response?.data}');
    log('# ==========================');

    if (err.response?.statusCode == 498) {
      await _handleSessionExpiredError(err, handler);
      return;
    }

    super.onError(err, handler);
  }

  Future<void> _handleSessionExpiredResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (!_shouldAttemptSessionRecovery(response.requestOptions)) {
      handler.reject(_sessionExpiredException(response.requestOptions, response));
      return;
    }

    final recovered = await _recoverSessionOnce();
    if (!recovered) {
      handler.reject(_sessionExpiredException(response.requestOptions, response));
      return;
    }

    try {
      final retried = await _replay(response.requestOptions);
      handler.resolve(retried);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }

  Future<void> _handleSessionExpiredError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldAttemptSessionRecovery(err.requestOptions)) {
      handler.next(err);
      return;
    }

    final recovered = await _recoverSessionOnce();
    if (!recovered) {
      handler.next(err);
      return;
    }

    try {
      final retried = await _replay(err.requestOptions);
      handler.resolve(retried);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldAttemptSessionRecovery(RequestOptions options) {
    final skipAuth = options.extra['skipAuth'] as bool? ?? false;
    final alreadyRetried = options.extra[_sessionRecoveryAttemptedKey] == true;
    return !skipAuth && !alreadyRetried;
  }

  Future<bool> _recoverSessionOnce() {
    final existing = _inFlightSessionRecovery;
    if (existing != null) return existing;

    final future = appContainer.read(loginProvider.notifier).login().whenComplete(
      () {
        _inFlightSessionRecovery = null;
      },
    );
    _inFlightSessionRecovery = future;
    return future;
  }

  Future<Response<dynamic>> _replay(RequestOptions requestOptions) {
    final replayOptions = requestOptions.copyWith(
      extra: {
        ...requestOptions.extra,
        _sessionRecoveryAttemptedKey: true,
      },
    );

    return _clients.offlineEngine.dio.fetch<dynamic>(replayOptions);
  }

  DioException _sessionExpiredException(
    RequestOptions requestOptions,
    Response response,
  ) {
    return DioException(
      requestOptions: requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      message: 'Session expired',
    );
  }
}
