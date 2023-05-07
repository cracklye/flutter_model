import 'package:example/notes/model_notes.dart';
import 'package:example/notes/widget/note_display.dart';
import 'package:example/notes/widget/note_form.dart';
import 'package:example/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/flutter_model.dart';

class NotesScreenListSingle extends ModelScreenList<Notes> {
  NotesScreenListSingle({Key? key})
      : super(
          key: key,
          drawer: const AppDrawer(),
          title: "Notes",
        );

  @override
  Widget buildDetailDisplayForModel(
      BuildContext context, ModelEditViewStateView<Notes> state, Notes? model) {
    if (model == null) return const Text("Model is null");
    return NotesDisplay(model: model);
  }

  @override
  Widget buildForm(
    BuildContext context,
    ModelEditViewStateEdit<Notes> state,
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
