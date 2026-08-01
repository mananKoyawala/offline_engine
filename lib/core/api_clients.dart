import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/app_headers.dart';
import 'package:offline_engine/core/base_url.dart';
import 'package:offline_engine/core/global_getters.dart';
import 'package:offline_engine/core/interceptors.dart';

@lazySingleton
class APIClients {
  late final JClient offlineEngine;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    offlineEngine = await JClient.initClient(
      _getJClientSetup(
        BaseUrls.offlineEngineBaseUrl,
        clientInterceptors: [AppInterceptor(clients: this)],
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
      onSessionExpired: onSessionExpired ?? () {},
    );
  }
}

// TODO :
/* 
1. Update client version in task and sync operation (done)
2. Static login and refresh token generator
3. Conflict resolver
4. Queue operation merger
*/
