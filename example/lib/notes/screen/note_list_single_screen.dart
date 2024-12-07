import 'package:example/notes/model_notes.dart';
import 'package:example/notes/widget/note_display.dart';
import 'package:example/notes/widget/note_form.dart';
import 'package:example/routes/app_navigator.dart';
import 'package:extended_list_view/extended_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class NotesScreenListScreen extends ModelScreenListScreen<Notes> {
  NotesScreenListScreen({
    super.key,
    super.editActionStyle = ActionStyle.uri,
    super.displayActionStyle = ActionStyle.uri,
    super.createActionStyle = ActionStyle.uri,
    super.drawer = const AppDrawer(),
    super.title = "Notes",
     super.enableSplit = true,
  });

  @override
  Widget buildDetailDisplayForModel(BuildContext context,
      ModelEditViewStateLoaded<Notes> state, Notes? model) {
    if (model == null) return const Text("Model is null");
    return NotesDisplay(model: model);
  }

  @override
  List<ListViewLayoutDefault<Notes>> getListDataProviders() {
    return [
      ListViewLayoutList(selectIcon: Icons.abc),
      ListViewLayoutList(selectIcon: Icons.ac_unit_rounded),
    ];
  }

  @override
  List<ListViewOrderByItem> getOrderBy() {
    return [
      ListViewOrderByItem(
          label: "Name Asc",
          value: [SortOrderByFieldName("note_name_asc", "name", true)]),
      ListViewOrderByItem(
          label: "Name Desc",
          value: [SortOrderByFieldName("note_name_desc", "name", false)]),
      ListViewOrderByItem(label: "Modified", value: [
        SortOrderByFieldName("note_modified", "modifiedDate", false)
      ]),
    ];
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
