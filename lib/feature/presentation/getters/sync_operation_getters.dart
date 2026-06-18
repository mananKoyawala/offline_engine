import 'package:offline_engine/feature/domain/usecases/sync_operation_usecases.dart';
import 'package:offline_engine/locator/locator.dart';

GetSyncOperationLocalUsecase get getSyncOperationLocalUsecase =>
    locator<GetSyncOperationLocalUsecase>();

GetSyncOperationStreamLocalUsecase get getSyncOperationStreamLocalUsecase =>
    locator<GetSyncOperationStreamLocalUsecase>();
