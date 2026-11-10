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
import 'package:todus/core/api_clients.dart' as _i193;
import 'package:todus/core/database/app_database.dart' as _i981;
import 'package:todus/core/import/app_imports.dart' as _i314;
import 'package:todus/core/shared_preferences.dart' as _i143;
import 'package:todus/feature/login/data/repository/login_repository_impl.dart'
    as _i870;
import 'package:todus/feature/login/domain/repository/login_repository.dart'
    as _i485;
import 'package:todus/feature/login/domain/usecases/login_usecases.dart'
    as _i605;
import 'package:todus/feature/register/data/repository/otp_repository_impl.dart'
    as _i463;
import 'package:todus/feature/register/data/repository/register_repository_impl.dart'
    as _i833;
import 'package:todus/feature/register/domain/repository/otp_repository.dart'
    as _i418;
import 'package:todus/feature/register/domain/repository/register_repository.dart'
    as _i734;
import 'package:todus/feature/register/domain/usecases/otp_usecases.dart'
    as _i382;
import 'package:todus/feature/register/domain/usecases/register_usecases.dart'
    as _i419;
import 'package:todus/feature/tasks/data/datasources/local/sync_operations_local_data_source.dart'
    as _i325;
import 'package:todus/feature/tasks/data/datasources/local/sync_operations_local_data_source_impl.dart'
    as _i734;
import 'package:todus/feature/tasks/data/datasources/local/task_local_data_source.dart'
    as _i276;
import 'package:todus/feature/tasks/data/datasources/local/task_local_data_source_impl.dart'
    as _i215;
import 'package:todus/feature/tasks/data/datasources/remote/task_remote_data_source.dart'
    as _i187;
import 'package:todus/feature/tasks/data/datasources/remote/task_remote_data_source_impl.dart'
    as _i778;
import 'package:todus/feature/tasks/data/repository/sync_operation_repository_impl.dart'
    as _i1008;
import 'package:todus/feature/tasks/data/repository/task_repository_impl.dart'
    as _i13;
import 'package:todus/feature/tasks/domain/repository/sync_operation_repository.dart'
    as _i720;
import 'package:todus/feature/tasks/domain/repository/task_repository.dart'
    as _i551;
import 'package:todus/feature/tasks/domain/usecases/sync_operation_usecases.dart'
    as _i562;
import 'package:todus/feature/tasks/domain/usecases/task_usecases.dart'
    as _i326;
import 'package:todus/service/network/internet_service/internet_service.dart'
    as _i757;
import 'package:todus/service/sync/queue_manager/queue_manager.dart' as _i373;
import 'package:todus/service/sync/sync_event_bus/sync_event_bus.dart' as _i338;
import 'package:todus/service/sync/sync_manager/sync_manager.dart' as _i990;
import 'package:todus/service/sync/sync_processor/repository/sync_processor_repository.dart'
    as _i944;
import 'package:todus/service/sync/sync_processor/repository/sync_processor_repository_impl.dart'
    as _i809;
import 'package:todus/service/sync/sync_processor/usecase/sync_manager_usecases.dart'
    as _i622;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await gh.lazySingletonAsync<_i193.APIClients>(() {
      final i = _i193.APIClients();
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.lazySingleton<_i981.AppDatabase>(() => _i981.AppDatabase());
    await gh.lazySingletonAsync<_i143.Preferences>(() {
      final i = _i143.Preferences();
      return i.initialize().then((_) => i);
    }, preResolve: true);
    gh.lazySingleton<_i757.InternetService>(() => _i757.InternetService());
    gh.lazySingleton<_i373.QueueManager>(() => _i373.QueueManager());
    gh.lazySingleton<_i338.SyncEventBus>(
      () => _i338.SyncEventBus(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i325.SyncOperationsLocalDataSource>(
      () => _i734.SyncOperationsLocalDataSourceImpl(gh<_i981.AppDatabase>()),
    );
    gh.lazySingleton<_i944.ISyncProcessorRepository>(
      () => _i809.SyncProcessorRepositoryImpl(gh<_i193.APIClients>()),
    );
    gh.lazySingleton<_i622.SyncOperationUsecase>(
      () => _i622.SyncOperationUsecase(gh<_i944.ISyncProcessorRepository>()),
    );
    gh.lazySingleton<_i187.TaskRemoteDataSource>(
      () => _i778.TaskRemoteDataSourceImpl(gh<_i193.APIClients>()),
    );
    gh.lazySingleton<_i276.TaskLocalDataSource>(
      () => _i215.TaskLocalDataSourceImpl(
        gh<_i314.AppDatabase>(),
        gh<_i338.SyncEventBus>(),
      ),
    );
    gh.lazySingleton<_i990.SyncManager>(
      () => _i990.SyncManager(
        gh<_i373.QueueManager>(),
        gh<_i757.InternetService>(),
        gh<_i338.SyncEventBus>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i720.ISyncOperationRepository>(
      () => _i1008.SyncOperationRepositoryImpl(
        gh<_i325.SyncOperationsLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i485.ILoginRepository>(
      () => _i870.LoginRepositoryImpl(clients: gh<_i193.APIClients>()),
    );
    gh.lazySingleton<_i734.IRegisterRepository>(
      () => _i833.RegisterRepositoryImpl(clients: gh<_i193.APIClients>()),
    );
    gh.lazySingleton<_i605.LoginUsecases>(
      () => _i605.LoginUsecases(loginRepository: gh<_i485.ILoginRepository>()),
    );
    gh.lazySingleton<_i418.IOtpRepository>(
      () => _i463.OtpRepositoryImpl(clients: gh<_i193.APIClients>()),
    );
    gh.lazySingleton<_i551.ITaskRepository>(
      () => _i13.TaskRepositoryImpl(
        gh<_i276.TaskLocalDataSource>(),
        gh<_i187.TaskRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i419.RegisterUsecases>(
      () => _i419.RegisterUsecases(
        registerRepository: gh<_i734.IRegisterRepository>(),
      ),
    );
    gh.lazySingleton<_i382.OtpUsecases>(
      () => _i382.OtpUsecases(otpRepository: gh<_i418.IOtpRepository>()),
    );
    gh.lazySingleton<_i562.GetSyncOperationLocalUsecase>(
      () => _i562.GetSyncOperationLocalUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.GetSyncOperationStreamLocalUsecase>(
      () => _i562.GetSyncOperationStreamLocalUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.GetPendingCountLocalUsecase>(
      () => _i562.GetPendingCountLocalUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.GetMergedCountLocalUsecase>(
      () => _i562.GetMergedCountLocalUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.GetAutoResolvedCountLocalUsecase>(
      () => _i562.GetAutoResolvedCountLocalUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.GetSuccessCountLocalUsecase>(
      () => _i562.GetSuccessCountLocalUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.GetFailedCountLocalUsecase>(
      () => _i562.GetFailedCountLocalUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.GetCreateCountLocalUsecase>(
      () => _i562.GetCreateCountLocalUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.GetUpdateCountLocalUsecase>(
      () => _i562.GetUpdateCountLocalUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.GetDeleteCountLocalUsecase>(
      () => _i562.GetDeleteCountLocalUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.MarkOperationSuccessUsecase>(
      () => _i562.MarkOperationSuccessUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.MarkOperationFailedUsecase>(
      () => _i562.MarkOperationFailedUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.GetAllPendingOperationsUsecase>(
      () => _i562.GetAllPendingOperationsUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.MarkOperationMergedUsecase>(
      () => _i562.MarkOperationMergedUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.MarkOperationAutoResolvedUsecase>(
      () => _i562.MarkOperationAutoResolvedUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.SolveVersionMismatchConflictUsecase>(
      () => _i562.SolveVersionMismatchConflictUsecase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.SolveAlreadyDeletedConflictUseCase>(
      () => _i562.SolveAlreadyDeletedConflictUseCase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.SolveDeletedConflictUseCase>(
      () => _i562.SolveDeletedConflictUseCase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i562.SolveDuplicateCreatedConflictUseCase>(
      () => _i562.SolveDuplicateCreatedConflictUseCase(
        gh<_i720.ISyncOperationRepository>(),
      ),
    );
    gh.lazySingleton<_i326.GetTasksLocalUsecase>(
      () => _i326.GetTasksLocalUsecase(gh<_i551.ITaskRepository>()),
    );
    gh.lazySingleton<_i326.CreateTasksLocalUsecase>(
      () => _i326.CreateTasksLocalUsecase(gh<_i551.ITaskRepository>()),
    );
    gh.lazySingleton<_i326.UpdateTasksLocalUsecase>(
      () => _i326.UpdateTasksLocalUsecase(gh<_i551.ITaskRepository>()),
    );
    gh.lazySingleton<_i326.DeleteTasksLocalUsecase>(
      () => _i326.DeleteTasksLocalUsecase(gh<_i551.ITaskRepository>()),
    );
    gh.lazySingleton<_i326.FetchAndUpsertTasksUsecase>(
      () => _i326.FetchAndUpsertTasksUsecase(gh<_i551.ITaskRepository>()),
    );
    return this;
  }
}
