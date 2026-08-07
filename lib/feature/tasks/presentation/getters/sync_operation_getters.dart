import 'package:offline_engine/feature/tasks/domain/usecases/sync_operation_usecases.dart';
import 'package:offline_engine/locator/locator.dart';

GetSyncOperationLocalUsecase get getSyncOperationLocalUsecase =>
    locator<GetSyncOperationLocalUsecase>();

GetSyncOperationStreamLocalUsecase get getSyncOperationStreamLocalUsecase =>
    locator<GetSyncOperationStreamLocalUsecase>();

GetPendingCountLocalUsecase get getPendingCountLocalUsecase =>
    locator<GetPendingCountLocalUsecase>();

GetMergedCountLocalUsecase get getMergedCountLocalUsecase =>
    locator<GetMergedCountLocalUsecase>();

GetAutoResolvedCountLocalUsecase get getAutoResolvedCountLocalUsecase =>
    locator<GetAutoResolvedCountLocalUsecase>();

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

MarkOperationFailedUsecase get markOperationFailedUsecase =>
    locator<MarkOperationFailedUsecase>();

MarkOperationSuccessUsecase get markOperationSuccessUsecase =>
    locator<MarkOperationSuccessUsecase>();

MarkOperationMergedUsecase get markOperationMergedUsecase =>
    locator<MarkOperationMergedUsecase>();

MarkOperationAutoResolvedUsecase get markOperationAutoResolvedUsecase =>
    locator<MarkOperationAutoResolvedUsecase>();

GetAllPendingOperationsUsecase get getAllPendingOperationsUsecase =>
    locator<GetAllPendingOperationsUsecase>();

SolveVersionMismatchConflictUsecase get solveVersionMismatchConflictUsecase =>
    locator<SolveVersionMismatchConflictUsecase>();

SolveAlreadyDeletedConflictUseCase get solveAlreadyDeletedConflictUseCase =>
    locator<SolveAlreadyDeletedConflictUseCase>();

SolveDeletedConflictUseCase get solveDeletedConflictUseCase =>
    locator<SolveDeletedConflictUseCase>();

SolveDuplicateCreatedConflictUseCase get solveDuplicateCreatedConflictUseCase =>
    locator<SolveDuplicateCreatedConflictUseCase>();
