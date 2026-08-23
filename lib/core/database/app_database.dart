import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_engine/core/database/daos/sync_operations_dao.dart';
import 'package:offline_engine/core/database/daos/task_dao.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@lazySingleton
@DriftDatabase(tables: [Tasks, SyncOperations])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      await m.deleteTable('tasks');
      await m.deleteTable('sync_operations');

      await m.createAll();
    },
  );

  Future<void> clearAllData() async {
    await transaction(() async {
      await customStatement('DELETE FROM sync_operations');
      await customStatement('DELETE FROM tasks');
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(p.join(dir.path, 'offline_engine.sqlite'));

    return NativeDatabase(file);
  });
}
