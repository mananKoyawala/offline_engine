import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/data/datasources/local/task_local_data_source.dart';

@LazySingleton(as: TaskLocalDataSource)
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final AppDatabase database;

  TaskLocalDataSourceImpl(this.database);

  // TODO : ALL NOT NULL CHECK FOR LIST TO GET WHILE DELETE SO DELETED NOT APPEARED
  @override
  Future<List<TaskItem>> getTasks() async {
    final result = await (database.select(
      database.tasks,
    )..where((t) => t.deletedAt.isNull())).get();

    return result.map(TaskItem.fromDrift).toList();
  }

  @override
  Future<bool> insertTask(CreateTaskParams task) async {
    return !(await database
            .into(database.tasks)
            .insert(
              TasksCompanion(
                title: Value(task.title),
                description: Value(task.description),
                priority: Value(task.priority.value),
              ),
            ) <=
        0);
  }

  @override
  Future<bool> updateTask(UpdateTaskParams task) async {
    return !(await (database.update(
          database.tasks,
        )..where((t) => t.id.equals(task.id))).write(
          TasksCompanion(
            title: Value(task.title),
            description: Value(task.description),
            priority: Value(task.priority.value),
            isCompleted: Value(task.isCompleted),
          ),
        ) <=
        0);
  }

  @override
  Future<bool> deleteTask(String taskId) async {
    return !(await (database.update(database.tasks)
              ..where((t) => t.id.equals(taskId)))
            .write(TasksCompanion(deletedAt: Value(DateTime.now()))) <=
        0);
  }
}
