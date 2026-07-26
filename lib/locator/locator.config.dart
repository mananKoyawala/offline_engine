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
import 'package:offline_engine/feature/data/datasources/local/sync_operations_local_data_source.dart'
    as _i1066;
import 'package:offline_engine/feature/data/datasources/local/sync_operations_local_data_source_impl.dart'
    as _i769;
import 'package:offline_engine/feature/data/datasources/local/task_local_data_source.dart'
    as _i717;
import 'package:offline_engine/feature/data/datasources/local/task_local_data_source_impl.dart'
    as _i449;
import 'package:offline_engine/feature/data/datasources/remote/task_remote_data_source.dart'
    as _i99;
import 'package:offline_engine/feature/data/datasources/remote/task_remote_data_source_impl.dart'
    as _i614;
import 'package:offline_engine/feature/data/repository/sync_operation_repository_impl.dart'
    as _i968;
import 'package:offline_engine/feature/data/repository/task_repository_impl.dart'
    as _i208;
import 'package:offline_engine/feature/domain/repository/sync_operation_repository.dart'
    as _i427;
import 'package:offline_engine/feature/domain/repository/task_repository.dart'
    as _i252;
import 'package:offline_engine/feature/domain/usecases/sync_operation_usecases.dart'
    as _i13;
import 'package:offline_engine/feature/domain/usecases/task_usecases.dart'
    as _i25;
import 'package:offline_engine/service/queue_manager/queue_manager.dart'
    as _i178;
import 'package:offline_engine/service/sync_manager/sync_manager.dart' as _i762;
import 'package:offline_engine/service/sync_processor/repository/sync_processor_repository.dart'
    as _i570;
import 'package:offline_engine/service/sync_processor/repository/sync_processor_repository_impl.dart'
    as _i722;
import 'package:offline_engine/service/sync_processor/usecase/sync_manager_usecases.dart'
    as _i116;

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
    gh.lazySingleton<_i178.QueueManager>(() => _i178.QueueManager());
    gh.factory<_i762.SyncManager>(
      () => _i762.SyncManager(gh<_i178.QueueManager>())..initialize(),
    );
    gh.lazySingleton<_i570.ISyncProcessorRepository>(
      () => _i722.SyncProcessorRepositoryImpl(gh<_i626.APIClients>()),
    );
    gh.lazySingleton<_i99.TaskRemoteDataSource>(
      () => _i614.TaskRemoteDataSourceImpl(gh<_i467.AppDatabase>()),
    );
    gh.lazySingleton<_i717.TaskLocalDataSource>(
      () => _i449.TaskLocalDataSourceImpl(gh<_i467.AppDatabase>()),
    );
    gh.lazySingleton<_i252.ITaskRepository>(
      () => _i208.TaskRepositoryImpl(
        gh<_i717.TaskLocalDataSource>(),
        gh<_i99.TaskRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1066.SyncOperationsLocalDataSource>(
      () => _i769.SyncOperationsLocalDataSourceImpl(gh<_i410.AppDatabase>()),
    );
    gh.lazySingleton<_i116.SyncOperationUsecase>(
      () => _i116.SyncOperationUsecase(gh<_i570.ISyncProcessorRepository>()),
    );
    gh.lazySingleton<_i427.ISyncOperationRepository>(
      () => _i968.SyncOperationRepositoryImpl(
        gh<_i1066.SyncOperationsLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i25.GetTasksLocalUsecase>(
      () => _i25.GetTasksLocalUsecase(gh<_i252.ITaskRepository>()),
    );
    gh.lazySingleton<_i25.CreateTasksLocalUsecase>(
      () => _i25.CreateTasksLocalUsecase(gh<_i252.ITaskRepository>()),
    );
    gh.lazySingleton<_i25.UpdateTasksLocalUsecase>(
      () => _i25.UpdateTasksLocalUsecase(gh<_i252.ITaskRepository>()),
    );
    gh.lazySingleton<_i25.DeleteTasksLocalUsecase>(
      () => _i25.DeleteTasksLocalUsecase(gh<_i252.ITaskRepository>()),
    );
    gh.lazySingleton<_i13.GetSyncOperationLocalUsecase>(
      () => _i13.GetSyncOperationLocalUsecase(
        gh<_i427.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i13.GetSyncOperationStreamLocalUsecase>(
      () => _i13.GetSyncOperationStreamLocalUsecase(
        gh<_i427.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i13.GetPendingCountLocalUsecase>(
      () => _i13.GetPendingCountLocalUsecase(
        gh<_i427.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i13.GetProcessingCountLocalUsecase>(
      () => _i13.GetProcessingCountLocalUsecase(
        gh<_i427.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i13.GetSuccessCountLocalUsecase>(
      () => _i13.GetSuccessCountLocalUsecase(
        gh<_i427.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i13.GetFailedCountLocalUsecase>(
      () =>
          _i13.GetFailedCountLocalUsecase(gh<_i427.ISyncOperationRepository>()),
    );
    gh.lazySingleton<_i13.GetCreateCountLocalUsecase>(
      () =>
          _i13.GetCreateCountLocalUsecase(gh<_i427.ISyncOperationRepository>()),
    );
    gh.lazySingleton<_i13.GetUpdateCountLocalUsecase>(
      () =>
          _i13.GetUpdateCountLocalUsecase(gh<_i427.ISyncOperationRepository>()),
    );
    gh.lazySingleton<_i13.GetDeleteCountLocalUsecase>(
      () =>
          _i13.GetDeleteCountLocalUsecase(gh<_i427.ISyncOperationRepository>()),
    );
    gh.lazySingleton<_i13.MarkOperationSuccessUsecase>(
      () => _i13.MarkOperationSuccessUsecase(
        gh<_i427.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i13.MarkOperationFailedUsecase>(
      () =>
          _i13.MarkOperationFailedUsecase(gh<_i427.ISyncOperationRepository>()),
    );
    gh.lazySingleton<_i13.GetAllPendingOperationsUsecase>(
      () => _i13.GetAllPendingOperationsUsecase(
        gh<_i427.ISyncOperationRepository>(),
      ),
    );
    return this;
  }
}
