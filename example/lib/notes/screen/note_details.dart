// import 'package:flutter/material.dart';

import 'package:example/notes/model_notes.dart';
import 'package:example/notes/widget/note_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class NoteDetailScreen extends ModelScreenDetail<Notes> {
  NoteDetailScreen({
    required super.id,
    super.key,
  }) : super(onDeleted: (context) => Navigator.of(context).pop());

  @override
  Widget buildDetailBlocContent(
      BuildContext context, ModelEditViewState<Notes> state) {
    if (state.isEmpty) {
      return const CircularProgressIndicator();
    }

    return SingleChildScrollView(child: NotesDisplay(model: state.model!));
  }

  // @override
  // Widget buildDetailBlocLoaded(
  //     BuildContext context, ModelEditViewStateLoaded<Notes> state) {
  //   return SingleChildScrollView(child: NotesDisplay(model: state.model));
  // }
}
