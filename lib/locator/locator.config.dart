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
import 'package:offline_engine/core/database/app_database.dart' as _i410;
import 'package:offline_engine/core/import/app_imports.dart' as _i467;
import 'package:offline_engine/feature/data/datasources/local/task_local_data_source.dart'
    as _i717;
import 'package:offline_engine/feature/data/datasources/local/task_local_data_source_impl.dart'
    as _i449;
import 'package:offline_engine/feature/data/datasources/remote/task_remote_data_source.dart'
    as _i99;
import 'package:offline_engine/feature/data/datasources/remote/task_remote_data_source_impl.dart'
    as _i614;
import 'package:offline_engine/feature/data/repository/task_repository_impl.dart'
    as _i208;
import 'package:offline_engine/feature/domain/repository/task_repository.dart'
    as _i252;
import 'package:offline_engine/feature/domain/usecases/task_usecases.dart'
    as _i25;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i410.AppDatabase>(() => _i410.AppDatabase());
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
    return this;
  }
}
