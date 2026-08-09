import 'dart:async';

import 'package:injectable/injectable.dart';

@lazySingleton
class SyncEventBus {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get onTaskWritten => _controller.stream;

  void notifyTaskWritten() {
    if (!_controller.isClosed) {
      _controller.add(null);
    }
  }

  @disposeMethod
  void dispose() {
    _controller.close();
  }
}
