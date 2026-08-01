import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/app_headers.dart';
import 'package:offline_engine/core/base_url.dart';
import 'package:offline_engine/core/interceptors.dart';

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
      getToken: () =>
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIzNTA2N2I5LTFjZDMtNGM1Ny1iNThkLTBmNDY4OGExY2Q4OCIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzg1NTgxNzcwLCJleHAiOjE3ODU1ODMxNzB9.5v9dcSKwJxde9o3XlKfCF7rSu72qqq3eMj36gbL-HCQ',
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