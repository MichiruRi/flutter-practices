import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

import '../models/note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final searchCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  late Realm realm;
  late List<Note> notes;

  void initRealm() {
    var config = Configuration.local([Note.schema]);
    realm = Realm(config);
  }

  void loadNotes() {
    notes = realm
        .all<Note>()
        .where((element) =>
            element.title
                .toLowerCase()
                .contains(searchCtrl.text.toLowerCase()) ||
            element.content
                .toLowerCase()
                .contains(searchCtrl.text.toLowerCase()) ||
            element.date
                .toString()
                .toLowerCase()
                .contains(searchCtrl.text.toLowerCase()) ||
            DateFormat.yMMMMEEEEd()
                .format(element.date!)
                .toString()
                .toLowerCase()
                .contains(searchCtrl.text.toLowerCase()))
        .toList();
    setState(() {});
  }

  void addNote() {
    if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
      Note note = Note(titleCtrl.text, contentCtrl.text, date: DateTime.now());
      realm.write(
        () => realm.add(note),
      );
      loadNotes();
      Navigator.of(context).pop();
    }
  }

  void updateNote(int index) {
    if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
      realm.write(() {
        notes[index].title = titleCtrl.text;
        notes[index].content = contentCtrl.text;
        notes[index].date = DateTime.now();
      });
      loadNotes();
      Navigator.of(context).pop();
    }
  }

  void deleteNote(Note note) {
    realm.write(() => realm.delete(note));
  }

  void clearCtrls() {
    titleCtrl.clear();
    contentCtrl.clear();
  }

  @override
  void initState() {
    super.initState();
    initRealm();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Notes'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: searchCtrl,
                onChanged: (value) => loadNotes(),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search notes',
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    var note = notes[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) => deleteNote(note),
                      direction: DismissDirection.startToEnd,
                      background: Card(
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      child: Card(
                        child: ListTile(
                          onTap: () => showAlertDialogue('Update',
                              note: note, index: index),
                          title: Text(note.title),
                          subtitle: Text(note.content),
                          trailing: Text(
                              '${DateFormat.yMMMMd().format(note.date!)} - ${DateFormat.jm().format(note.date!)}'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => showAlertDialogue('Add'),
        child: Icon(Icons.add),
      ),
    );
  }

  void showAlertDialogue(String action, {note, index}) {
    clearCtrls();
    if (action == 'Update') {
      titleCtrl.text = note.title;
      contentCtrl.text = note.content;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$action Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Title',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentCtrl,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Content',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => action == 'Add' ? addNote() : updateNote(index),
              child: Text(action),
            ),
          ],
        );
      },
    );
  }
}
