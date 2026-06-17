import 'package:offline_engine/core/import/app_imports.dart';

abstract class ISyncOperationRepository {
  Future<List<SyncOperationItem>> getSyncOperations();
}
