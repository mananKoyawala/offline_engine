import 'package:injectable/injectable.dart';
import 'package:offline_engine/core/database/app_database.dart';
import 'package:offline_engine/feature/data/datasources/local/sync_operations_local_data_source.dart';
import 'package:offline_engine/feature/data/models/sync_operation_item.dart';

@LazySingleton(as: SyncOperationsLocalDataSource)
class SyncOperationsLocalDataSourceImpl
    implements SyncOperationsLocalDataSource {
  final AppDatabase database;

  SyncOperationsLocalDataSourceImpl(this.database);

  @override
  Future<List<SyncOperationItem>> getSyncOperations() async {
    final result = await database.select(database.syncOperations).get();

    return result.map(SyncOperationItem.fromDrift).toList();
  }
}
