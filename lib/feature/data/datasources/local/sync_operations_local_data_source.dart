import 'package:offline_engine/core/import/app_imports.dart';

abstract class SyncOperationsLocalDataSource {
  Future<List<SyncOperationItem>> getSyncOperations();
}
