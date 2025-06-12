import 'package:drift/drift.dart' as db;
import 'package:eko/widgets/animated_appbar.dart';
import 'package:eko/widgets/custom_alert_dialog.dart';
import 'package:eko/widgets/list_item_group.dart';
import 'package:eko/db/database.dart';
import 'package:eko/extensions/scroll_controller.dart';
import 'package:eko/providers/notes.dart';
import 'package:eko/providers/settings.dart';
import 'package:eko/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListScreen extends HookConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useHidingAppBar();
    final notes = ref.watch(notesProvider);
    final notesNotifier = ref.watch(notesProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final preferredUnit = settings.preferredUnit;

    final total =
        notes.fold<double>(0, (prev, element) => prev + element.value);

    final isAddingNew = useState(false);
    final noteController = useTextEditingController();
    final valueController = useTextEditingController();
    final editingIndex = useState<int?>(-1);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.position.maxScrollExtent <= 0 &&
            !scrollController.isAppBarVisible) {
          scrollController.resetAppBarVisibility();
        }
      });
      return null;
    }, [notes.length]);

    return Scaffold(
      appBar: AnimatedAppBar(
        showAppBar: scrollController.isAppBarVisible,
        appBar: AppBar(
          title: const Text('Notes'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              tooltip: "Settings",
              icon: Icon(Icons.settings_outlined),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        child: Text(
          'Total: $preferredUnit${total.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: buildFAB(
        isAddingNew,
        notesNotifier,
        noteController,
        valueController,
        scrollController,
      ),
      body: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          if (notes.isNotEmpty || isAddingNew.value)
            buildNotesList(
              notes,
              notesNotifier,
              context,
              preferredUnit,
              editingIndex,
              scrollController,
            ),
          if (isAddingNew.value) const SizedBox(height: 12),
          if (isAddingNew.value)
            buildAddNewNote(noteController, valueController, preferredUnit),
          if (notes.isEmpty && !isAddingNew.value)
            const Center(child: Text("No notes in sight")),
        ],
      ),
    );
  }

  Widget buildFAB(
    ValueNotifier<bool> isAddingNew,
    NotesNotifier notesNotifier,
    TextEditingController noteController,
    TextEditingController valueController,
    ScrollController scrollController,
  ) {
    if (isAddingNew.value) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              isAddingNew.value = false;
              noteController.clear();
              valueController.clear();
            },
            mini: true,
            child: const Icon(Icons.close),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              notesNotifier.addNote(NotesCompanion(
                note: db.Value(noteController.text),
                value: db.Value(double.parse(valueController.text)),
              ));
              isAddingNew.value = false;
              noteController.clear();
              valueController.clear();
            },
            child: const Icon(Icons.check),
          ),
        ],
      );
    } else {
      return AnimatedScale(
        scale: scrollController.isAppBarVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 250),
        child: FloatingActionButton(
          onPressed: () {
            isAddingNew.value = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          },
          child: const Icon(Icons.add),
        ),
      );
    }
  }

  Widget buildNotesList(
    List<Note> notes,
    NotesNotifier notesNotifier,
    BuildContext context,
    String preferredUnit,
    ValueNotifier<int?> editingIndex,
    ScrollController scrollController,
  ) {
    return ListItemGroup(
      onItemDismissed: (index, item) async {
        final note = notes[index];
        final messenger = ScaffoldMessenger.of(context);

        final result = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                  onApprove: () => Navigator.of(context).pop(true),
                  onCancel: () => Navigator.of(context).pop(false),
                  content: const Text('Delete Note?'),
                  approveButtonText: "Delete",
                );
              },
            ) ??
            false;

        if (result) {
          notesNotifier.deleteNote(notes[index]);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients &&
                scrollController.position.maxScrollExtent <= 0) {
              scrollController.resetAppBarVisibility();
            }
          });

          messenger.showSnackBar(SnackBar(
            content: const Text('Note deleted'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => notesNotifier.addNote(note.toCompanion(true)),
            ),
          ));
        }

        return result;
      },
      children: List.generate(
        notes.length,
        (idx) {
          final note = notes[idx];

          if (editingIndex.value == idx) {
            return buildEditingNote(
                note, notesNotifier, preferredUnit, editingIndex);
          }

          return ListItem(
            onTap: () => editingIndex.value = idx,
            title: Text(note.note),
            trailing: Text(
              "$preferredUnit${note.value.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 14),
            ),
          );
        },
      ),
    );
  }

  ListItem buildEditingNote(
    Note note,
    NotesNotifier notesNotifier,
    String preferredUnit,
    ValueNotifier<int?> editingIndex,
  ) {
    final editNoteController = useTextEditingController(text: note.note);
    final editValueController =
        useTextEditingController(text: note.value.toString());

    return ListItem(
      title: TextField(
        controller: editNoteController,
        decoration: InputDecoration(hintText: 'Edit note'),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
              ],
              controller: editValueController,
              decoration: InputDecoration(hintText: '${preferredUnit}0.0'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          IconButton(
            icon: Icon(Icons.check, size: 20),
            onPressed: () {
              notesNotifier.updateNote(
                note
                    .copyWith(
                      note: editNoteController.text,
                      value: double.parse(editValueController.text),
                    )
                    .toCompanion(true),
              );
              editingIndex.value = -1;
            },
          ),
          IconButton(
            icon: Icon(Icons.close, size: 20),
            onPressed: () => editingIndex.value = -1,
          ),
        ],
      ),
    );
  }

  Widget buildAddNewNote(
    TextEditingController noteController,
    TextEditingController valueController,
    String preferredUnit,
  ) {
    return ListItemGroup(
      children: [
        ListItem(
          title: TextField(
            controller: noteController,
            decoration: InputDecoration(hintText: 'Enter note'),
          ),
          trailing: SizedBox(
            width: 80,
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
              ],
              controller: valueController,
              decoration: InputDecoration(hintText: '${preferredUnit}0.0'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ),
      ],
    );
  }
}
