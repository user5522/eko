import 'package:drift/drift.dart';
import 'package:eko/db/database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  AppDatabase db;

  NotesNotifier(this.db) : super([]) {
    getNotes();
  }

  Future loadEntries() async {
    final entries = await db.notes.select().get();
    state = entries;
  }

  Future<List<Note>> getNotes() async {
    final entries = await db.notes.select().get();
    state = entries;
    return entries;
  }

  Future addNote(NotesCompanion entry) async {
    await db.notes.insertOne(entry);
    state = await getNotes();
  }

  Future updateNote(NotesCompanion entry) async {
    await db.notes.update().replace(entry);
    state = await getNotes();
  }

  Future deleteNote(Note entry) async {
    await db.notes.deleteWhere((e) => e.id.equals(entry.id));
    state = await getNotes();
  }

  Future<void> resetData() async {
    await db.delete($NotesTable(db)).go();
    state = [];
  }

  Future<void> restoreState(List<Note> previousState) async {
    state = previousState;
    await db.notes.insertAll(state);
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
  (ref) => NotesNotifier(ref.watch(databaseProvider)),
);
