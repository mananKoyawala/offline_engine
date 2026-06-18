import 'package:offline_engine/feature/domain/usecases/sync_operation_usecases.dart';
import 'package:offline_engine/locator/locator.dart';

GetSyncOperationLocalUsecase get getSyncOperationLocalUsecase =>
    locator<GetSyncOperationLocalUsecase>();

GetSyncOperationStreamLocalUsecase get getSyncOperationStreamLocalUsecase =>
    locator<GetSyncOperationStreamLocalUsecase>();

GetPendingCountLocalUsecase get getPendingCountLocalUsecase =>
    locator<GetPendingCountLocalUsecase>();

GetProcessingCountLocalUsecase get getProcessingCountLocalUsecase =>
    locator<GetProcessingCountLocalUsecase>();

GetSuccessCountLocalUsecase get getSuccessCountLocalUsecase =>
    locator<GetSuccessCountLocalUsecase>();

GetFailedCountLocalUsecase get getFailedCountLocalUsecase =>
    locator<GetFailedCountLocalUsecase>();

GetCreateCountLocalUsecase get getCreateCountLocalUsecase =>
    locator<GetCreateCountLocalUsecase>();

GetUpdateCountLocalUsecase get getUpdateCountLocalUsecase =>
    locator<GetUpdateCountLocalUsecase>();

GetDeleteCountLocalUsecase get getDeleteCountLocalUsecase =>
    locator<GetDeleteCountLocalUsecase>();
