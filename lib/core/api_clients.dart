import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/app_headers.dart';
import 'package:offline_engine/core/base_url.dart';
import 'package:offline_engine/core/global_getters.dart';
import 'package:offline_engine/core/interceptors.dart';
import 'package:offline_engine/core/navigator_key.dart';
import 'package:offline_engine/feature/splash/presentation/pages/splash_page.dart';

@lazySingleton
class APIClients {
  late final JClient offlineEngine;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    offlineEngine = await JClient.initClient(
      _getJClientSetup(
        BaseUrls.offlineEngineBaseUrl,
        clientInterceptors: [AppInterceptor()],
      ),
    );
  }

  JClientSetup _getJClientSetup(
    String baseUrl, {
    VoidCallback? onSessionExpired,
    List<Interceptor> clientInterceptors = const [],
  }) {
    return JClientSetup(
      config: JClientConfig(receiveTimeout: const Duration(minutes: 2)),
      customInterceptors: clientInterceptors,
      baseUrl: baseUrl,
      getHeaders: () => AppHeaders.commonHeaders,
      getToken: () => prefsInstance.getAccessToken(),
      customSessionExpiryCodes: {401, 498},
      onSessionExpired:
          onSessionExpired ??
          () async {
            await prefsInstance.clearAuthSession();
            Fluttertoast.showToast(
              msg: 'Your session expired. Please sign in again.',
            );
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SpalshPage()),
              (_) => false,
            );
          },
    );
  }
}
