// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:offline_engine/core/api_clients.dart' as _i626;
import 'package:offline_engine/core/database/app_database.dart' as _i410;
import 'package:offline_engine/core/import/app_imports.dart' as _i467;
import 'package:offline_engine/core/shared_preferences.dart' as _i319;
import 'package:offline_engine/feature/login/data/repository/login_repository_impl.dart'
    as _i31;
import 'package:offline_engine/feature/login/domain/repository/login_repository.dart'
    as _i836;
import 'package:offline_engine/feature/login/domain/usecases/login_usecases.dart'
    as _i44;
import 'package:offline_engine/feature/tasks/data/datasources/local/sync_operations_local_data_source.dart'
    as _i537;
import 'package:offline_engine/feature/tasks/data/datasources/local/sync_operations_local_data_source_impl.dart'
    as _i340;
import 'package:offline_engine/feature/tasks/data/datasources/local/task_local_data_source.dart'
    as _i883;
import 'package:offline_engine/feature/tasks/data/datasources/local/task_local_data_source_impl.dart'
    as _i3;
import 'package:offline_engine/feature/tasks/data/datasources/remote/task_remote_data_source.dart'
    as _i662;
import 'package:offline_engine/feature/tasks/data/datasources/remote/task_remote_data_source_impl.dart'
    as _i367;
import 'package:offline_engine/feature/tasks/data/repository/sync_operation_repository_impl.dart'
    as _i860;
import 'package:offline_engine/feature/tasks/data/repository/task_repository_impl.dart'
    as _i662;
import 'package:offline_engine/feature/tasks/domain/repository/sync_operation_repository.dart'
    as _i1037;
import 'package:offline_engine/feature/tasks/domain/repository/task_repository.dart'
    as _i461;
import 'package:offline_engine/feature/tasks/domain/usecases/sync_operation_usecases.dart'
    as _i1046;
import 'package:offline_engine/feature/tasks/domain/usecases/task_usecases.dart'
    as _i1008;
import 'package:offline_engine/service/network/internet_service/internet_service.dart'
    as _i210;
import 'package:offline_engine/service/sync/queue_manager/queue_manager.dart'
    as _i695;
import 'package:offline_engine/service/sync/sync_event_bus/sync_event_bus.dart'
    as _i325;
import 'package:offline_engine/service/sync/sync_manager/sync_manager.dart'
    as _i841;
import 'package:offline_engine/service/sync/sync_processor/repository/sync_processor_repository.dart'
    as _i643;
import 'package:offline_engine/service/sync/sync_processor/repository/sync_processor_repository_impl.dart'
    as _i12;
import 'package:offline_engine/service/sync/sync_processor/usecase/sync_manager_usecases.dart'
    as _i53;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await gh.lazySingletonAsync<_i626.APIClients>(() {
      final i = _i626.APIClients();
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.lazySingleton<_i410.AppDatabase>(() => _i410.AppDatabase());
    await gh.lazySingletonAsync<_i319.Preferences>(() {
      final i = _i319.Preferences();
      return i.initialize().then((_) => i);
    }, preResolve: true);
    gh.lazySingleton<_i210.InternetService>(() => _i210.InternetService());
    gh.lazySingleton<_i695.QueueManager>(() => _i695.QueueManager());
    gh.lazySingleton<_i325.SyncEventBus>(
      () => _i325.SyncEventBus(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i643.ISyncProcessorRepository>(
      () => _i12.SyncProcessorRepositoryImpl(gh<_i626.APIClients>()),
    );
    gh.lazySingleton<_i841.SyncManager>(
      () => _i841.SyncManager(
        gh<_i695.QueueManager>(),
        gh<_i210.InternetService>(),
        gh<_i325.SyncEventBus>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i883.TaskLocalDataSource>(
      () => _i3.TaskLocalDataSourceImpl(
        gh<_i467.AppDatabase>(),
        gh<_i325.SyncEventBus>(),
      ),
    );
    gh.lazySingleton<_i53.SyncOperationUsecase>(
      () => _i53.SyncOperationUsecase(gh<_i643.ISyncProcessorRepository>()),
    );
    gh.lazySingleton<_i836.ILoginRepository>(
      () => _i31.LoginRepositoryImpl(clients: gh<_i626.APIClients>()),
    );
    gh.lazySingleton<_i662.TaskRemoteDataSource>(
      () => _i367.TaskRemoteDataSourceImpl(gh<_i626.APIClients>()),
    );
    gh.lazySingleton<_i537.SyncOperationsLocalDataSource>(
      () => _i340.SyncOperationsLocalDataSourceImpl(gh<_i410.AppDatabase>()),
    );
    gh.lazySingleton<_i44.LoginUsecases>(
      () => _i44.LoginUsecases(loginRepository: gh<_i836.ILoginRepository>()),
    );
    gh.lazySingleton<_i461.ITaskRepository>(
      () => _i662.TaskRepositoryImpl(
        gh<_i883.TaskLocalDataSource>(),
        gh<_i662.TaskRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1037.ISyncOperationRepository>(
      () => _i860.SyncOperationRepositoryImpl(
        gh<_i537.SyncOperationsLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i1008.GetTasksLocalUsecase>(
      () => _i1008.GetTasksLocalUsecase(gh<_i461.ITaskRepository>()),
    );
    gh.lazySingleton<_i1008.CreateTasksLocalUsecase>(
      () => _i1008.CreateTasksLocalUsecase(gh<_i461.ITaskRepository>()),
    );
    gh.lazySingleton<_i1008.UpdateTasksLocalUsecase>(
      () => _i1008.UpdateTasksLocalUsecase(gh<_i461.ITaskRepository>()),
    );
    gh.lazySingleton<_i1008.DeleteTasksLocalUsecase>(
      () => _i1008.DeleteTasksLocalUsecase(gh<_i461.ITaskRepository>()),
    );
    gh.lazySingleton<_i1008.FetchAndUpsertTasksUsecase>(
      () => _i1008.FetchAndUpsertTasksUsecase(gh<_i461.ITaskRepository>()),
    );
    gh.lazySingleton<_i1046.GetSyncOperationLocalUsecase>(
      () => _i1046.GetSyncOperationLocalUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.GetSyncOperationStreamLocalUsecase>(
      () => _i1046.GetSyncOperationStreamLocalUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.GetPendingCountLocalUsecase>(
      () => _i1046.GetPendingCountLocalUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.GetMergedCountLocalUsecase>(
      () => _i1046.GetMergedCountLocalUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.GetAutoResolvedCountLocalUsecase>(
      () => _i1046.GetAutoResolvedCountLocalUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.GetSuccessCountLocalUsecase>(
      () => _i1046.GetSuccessCountLocalUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.GetFailedCountLocalUsecase>(
      () => _i1046.GetFailedCountLocalUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.GetCreateCountLocalUsecase>(
      () => _i1046.GetCreateCountLocalUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.GetUpdateCountLocalUsecase>(
      () => _i1046.GetUpdateCountLocalUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.GetDeleteCountLocalUsecase>(
      () => _i1046.GetDeleteCountLocalUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.MarkOperationSuccessUsecase>(
      () => _i1046.MarkOperationSuccessUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.MarkOperationFailedUsecase>(
      () => _i1046.MarkOperationFailedUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.GetAllPendingOperationsUsecase>(
      () => _i1046.GetAllPendingOperationsUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.MarkOperationMergedUsecase>(
      () => _i1046.MarkOperationMergedUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.MarkOperationAutoResolvedUsecase>(
      () => _i1046.MarkOperationAutoResolvedUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.SolveVersionMismatchConflictUsecase>(
      () => _i1046.SolveVersionMismatchConflictUsecase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.SolveAlreadyDeletedConflictUseCase>(
      () => _i1046.SolveAlreadyDeletedConflictUseCase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.SolveDeletedConflictUseCase>(
      () => _i1046.SolveDeletedConflictUseCase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i1046.SolveDuplicateCreatedConflictUseCase>(
      () => _i1046.SolveDuplicateCreatedConflictUseCase(
        gh<_i1037.ISyncOperationRepository>(),
      ),
    );
    return this;
  }
}
