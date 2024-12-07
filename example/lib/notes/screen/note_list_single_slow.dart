import 'package:example/notes/model_notes.dart';
import 'package:example/notes/widget/note_display.dart';
import 'package:example/notes/widget/note_form.dart';
import 'package:example/repos/notes_repo_inmemory_slow.dart';
import 'package:example/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class NotesScreenListSingleSlow extends ModelScreenListScreen<Notes> {
  NotesScreenListSingleSlow({super.key})
      : super(
          drawer: const AppDrawer(),
          title: "Notes",
        );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IModelAPI<Notes>>(
        create: (context) => RepositoryNotesMemorySlow([
              Notes(
                  id: "1",
                  name: "Item 1",
                  description: "This is the first tiem"),
              Notes(
                  id: "2",
                  name: "Item 2",
                  description: "This is the first tiem"),
              Notes(
                  id: "3",
                  name: "Item 3",
                  description: "This is the first tiem"),
              Notes(
                  id: "4",
                  name: "Item 4",
                  description: "This is the first tiem"),
              Notes(
                  id: "5",
                  name: "Item 5",
                  description: "This is the first tiem"),
            ])
              ..init(),
        child: Builder(
          builder: (context) => super.build(context),
        ));
  }

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
