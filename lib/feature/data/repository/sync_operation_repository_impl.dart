import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/data/datasources/local/sync_operations_local_data_source.dart';
import 'package:offline_engine/feature/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/domain/repository/sync_operation_repository.dart';

@LazySingleton(as: ISyncOperationRepository)
class SyncOperationRepositoryImpl implements ISyncOperationRepository {
  final SyncOperationsLocalDataSource local;

  SyncOperationRepositoryImpl(this.local);

  @override
  Future<Either<ApiFailure, List<SyncOperationItem>>> getSyncOperations() {
    return local.getSyncOperations();
  }
}
