import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/database/app_database.dart';
import 'package:offline_engine/feature/data/datasources/local/sync_operations_local_data_source.dart';
import 'package:offline_engine/feature/data/models/sync_operation_item.dart';

@LazySingleton(as: SyncOperationsLocalDataSource)
class SyncOperationsLocalDataSourceImpl
    implements SyncOperationsLocalDataSource {
  final AppDatabase database;

  SyncOperationsLocalDataSourceImpl(this.database);

  @override
  Future<Either<ApiFailure, List<SyncOperationItem>>>
  getSyncOperations() async {
    try {
      final result = await database.select(database.syncOperations).get();

      return right(result.map(SyncOperationItem.fromDrift).toList());
    } catch (e) {
      return left(ApiFailure.unknown(e.toString()));
    }
  }
}
