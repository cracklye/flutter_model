// import 'package:flutter_bloc_modelframework/flutter_bloc_modelframework.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_geo_Notes/Notes/Notes_form.dart';
// import 'package:flutter_geo_Notes/model/Notes.dart';
import 'package:example/notes/model_notes.dart';
import 'package:example/notes/widget/note_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class NotesAddEditScreen extends ModelScreenEdit<Notes> {
  NotesAddEditScreen({super.key, super.id, super.parentId})
      : super(onSaved: (context) => Navigator.of(context).pop());
  @override
  Widget buildForm(
      BuildContext context,
      ModelEditViewStateLoaded<Notes> state,
      Notes? model,
      GlobalKey<FormState> formKey,
      void Function(Map<String, dynamic> onSave) onSave,
      Map<String, dynamic>? initalProperties) {
    return NotesForm(
      formKey: formKey,
      onSave: onSave,
      model: model,
    );
  }
  // @override
  // Widget buildForm(
  //   BuildContext context,
  //   ModelEditStateEdit<Notes> state,
  //   Notes? model,
  //   GlobalKey<FormState> formKey,
  //   void Function(Map<String, dynamic>) onSave,
  // ) {
  //   return NotesForm(
  //     formKey: formKey,
  //     onSave: onSave,
  //     model: model,
  //   );
  // }
}
