import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/app_headers.dart';
import 'package:offline_engine/core/base_url.dart';
import 'package:offline_engine/core/global_getters.dart';
import 'package:offline_engine/core/interceptors.dart';
import 'package:offline_engine/core/navigator_key.dart';
import 'package:offline_engine/feature/login/presentation/pages/login_page.dart';

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
          () {
            Fluttertoast.showToast(
              msg: 'You have to authorize you self again.',
            );
            Navigator.pushAndRemoveUntil(
              navigatorCtx,
              MaterialPageRoute(builder: (_) => LoginPage()),
              (_) => false,
            );
          },
    );
  }
}

// TODO :
/* 
1. Update client version in task and sync operation (done)
2. Static login and refresh token generator (done)
3. Queue operation merger (done)
4. Conflict resolver
*/
