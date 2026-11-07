import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/core/app_headers.dart';
import 'package:todus/core/base_url.dart';
import 'package:todus/core/global_getters.dart';
import 'package:todus/core/interceptors.dart';
import 'package:todus/core/navigator_key.dart';
import 'package:todus/feature/splash/presentation/pages/splash_page.dart';

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
            syncManagerInstance.reset();
            await appDatabaseInstance.clearAllData();
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
