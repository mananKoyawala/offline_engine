import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@lazySingleton
class InternetService {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    _isConnected = await InternetConnection().hasInternetAccess;
  }

  Stream<bool> get onStatusChanged {
    return InternetConnection().onStatusChange.map((status) {
      final connected = status == InternetStatus.connected;

      _isConnected = connected;

      return connected;
    });
  }
}
