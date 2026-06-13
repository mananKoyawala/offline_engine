import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/data/datasources/remote/task_remote_data_source.dart';

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final AppDatabase database;

  TaskRemoteDataSourceImpl(this.database);
}
