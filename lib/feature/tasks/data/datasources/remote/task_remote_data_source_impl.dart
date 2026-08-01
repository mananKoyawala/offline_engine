import 'package:injectable/injectable.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/tasks/data/datasources/remote/task_remote_data_source.dart';

@LazySingleton(as: TaskRemoteDataSource)
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final AppDatabase database;

  TaskRemoteDataSourceImpl(this.database);
}
