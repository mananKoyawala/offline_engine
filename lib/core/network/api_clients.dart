import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/network/base_urls.dart';
import 'package:offline_engine/core/network/interceptors.dart';

@lazySingleton
class APIClients {
  bool _initialized = false;
  late final JClient defaultClient;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    if (_initialized) return;
    defaultClient = await JClient.initClient(
      _getJClientSetup(
        BaseUrls.taskBaseUrl,
        clientInterceptors: [AppInterceptor()],
      ),
    );

    _initialized = true;
  }

  JClientSetup _getJClientSetup(
    String baseUrl, {
    VoidCallback? onSessionExpired,
    List<Interceptor> clientInterceptors = const [],
  }) {
    final interceptors = <Interceptor>[...clientInterceptors];
    return JClientSetup(
      config: const JClientConfig(receiveTimeout: Duration(minutes: 2)),
      customInterceptors: interceptors,
      baseUrl: baseUrl,
      onSessionExpired: onSessionExpired ?? () {},
      onSessionExpiredUnknown: () {},
    );
  }
}
