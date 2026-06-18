import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/presentation/getters/sync_operation_getters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_operation_provider.g.dart';

@riverpod
Stream<Either<ApiFailure, List<SyncOperationItem>>> syncOperations(Ref ref) {
  return getSyncOperationStreamLocalUsecase();
}

@riverpod
Stream<int> pendingCount(Ref ref) {
  return getPendingCountLocalUsecase();
}

@riverpod
Stream<int> failedCount(Ref ref) {
  return getFailedCountLocalUsecase();
}

@riverpod
Stream<int> processingCount(Ref ref) {
  return getProcessingCountLocalUsecase();
}

@riverpod
Stream<int> successCount(Ref ref) {
  return getSuccessCountLocalUsecase();
}

@riverpod
Stream<int> createCount(Ref ref) {
  return getCreateCountLocalUsecase();
}

@riverpod
Stream<int> updateCount(Ref ref) {
  return getUpdateCountLocalUsecase();
}

@riverpod
Stream<int> deleteCount(Ref ref) {
  return getDeleteCountLocalUsecase();
}
