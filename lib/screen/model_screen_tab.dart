import 'package:flutter/material.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_model/widgets/ui/page_header.dart';
import 'package:loggy/loggy.dart';

abstract class ModelScreenListTab<T extends IModel> extends ModelSinglePage<T>
    with UiLoggy {
  // final Widget? drawer;
  final String? title;

  //final String? parentId;
  ModelScreenListTab(
      {super.key,
      //  this.drawer,
      this.title,
      super.enableSplit = true,
      super.editActionStyle = ActionStyle.uri,
      super.displayActionStyle = ActionStyle.uri,
      super.createActionStyle = ActionStyle.uri,
      super.parentId});

      
  @override
  Widget buildDetailDisplay(
      BuildContext context, ModelEditViewStateLoaded<T> state, T? model) {
    List<Widget> actions = getItemActions(state, false)
        .map((e) => TextButton(
            onPressed: () => e.onSelected(context, model),
            child: Text(e.label)))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PageHeader(title: model?.displayLabel ?? "", actions: actions),
        buildDetailDisplayForModel(context, state, model)
      ],
    );
  }

  @override
  Widget buildDetailEdit(
      BuildContext context, ModelEditViewStateLoaded<T> state, T? model) {
    List<Widget> actions = getItemActions(state, false)
        .map((e) => TextButton(
            onPressed: () => e.onSelected(context, model),
            child: Text(e.label)))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
            title: model == null ? "Create" : "Edit ${model.displayLabel}",
            actions: actions),
        super.buildDetailEdit(context, state, model),
      ],
    );
  }
}
