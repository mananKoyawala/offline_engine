import 'package:offline_engine/locator/locator.dart';
import 'package:offline_engine/service/sync_processor/usecase/sync_manager_usecases.dart';

SyncOperationUsecase get syncOperationUsecase =>
    locator<SyncOperationUsecase>();
