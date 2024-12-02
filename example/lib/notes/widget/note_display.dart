import 'package:example/notes/model_notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/flutter_model.dart';

class NotesDisplay extends StatelessWidget {
  const NotesDisplay({super.key, required this.model});
  final Notes model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelWidget(
            buildLabel: const Text("Label"),
            buildContent: Text(model.displayLabel)),
        LabelWidget(
            buildLabel: const Text("Created Date"),
            buildContent: Text(model.createdDate.toString())),
        LabelWidget(
            buildLabel: const Text("Description"),
            buildContent: Text(model.description)),
      ],
    );
  }
}
