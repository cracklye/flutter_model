import 'package:example/notes/model_notes.dart';
import 'package:flutter/material.dart';


class NotesListItem extends StatelessWidget {
  final Notes note;
  final Function() onTap;

  const NotesListItem({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(note.displayLabel),
      subtitle: Text(note.description),
    );
  }
}
