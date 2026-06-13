import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

@DataClassName("Task")
class Tasks extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get priority => integer()
      .withDefault(const Constant(0))
      .check(
        const CustomExpression<bool>('priority BETWEEN -1 AND 1'),
      )(); // -1 -> low, 0 -> medium, 1 -> high
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
