import 'package:drift/drift.dart';

@DataClassName("SyncOperation")
class SyncOperations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskId => text()();
  TextColumn get type => text()(); // create, update, delete
  TextColumn get payload => text()();
  TextColumn get status => text()(); // pending, failed, success, processing
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
