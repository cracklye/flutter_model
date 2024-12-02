import 'package:example/notes/model_notes.dart';
import 'package:example/notes/widget/note_display.dart';
import 'package:example/notes/widget/note_form.dart';
import 'package:example/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/screen/model_screen_list2.dart';

class NotesScreenListSingle extends ModelScreenListActionBar<Notes> {
  NotesScreenListSingle({super.key})
      : super(
          drawer: const AppDrawer(),
          title: "Notes",
        );

  @override
  Widget buildDetailDisplayForModel(BuildContext context,
      ModelEditViewStateLoaded<Notes> state, Notes? model) {
    if (model == null) return const Text("Model is null");
    return NotesDisplay(model: model);
  }

  @override
  Widget buildForm(
    BuildContext context,
    ModelEditViewStateLoaded<Notes> state,
    Notes? model,
    GlobalKey<FormState> formKey,
    void Function(Map<String, dynamic>) onSave,
  ) {
    return NotesForm(
      model: model,
      formKey: formKey,
      onSave: onSave,
    );
  }
}
