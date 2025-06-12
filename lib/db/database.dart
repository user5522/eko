import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eko/db/connection/native.dart';
import 'package:eko/models/notes.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA journal_mode=WAL');
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }
}

final StateProvider<AppDatabase> databaseProvider = StateProvider((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);

  return database;
});
