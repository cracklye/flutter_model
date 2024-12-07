import 'package:flutter/material.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

abstract class ModelScreenListScreen<T extends IModel>
    extends ModelSinglePage<T> with UiLoggy {
  final Widget? drawer;
  final String? title;

  ModelScreenListScreen(
      {super.key,
      super.enableSplit = true,
      this.drawer,
      this.title,
      super.editActionStyle = ActionStyle.uri,
      super.displayActionStyle = ActionStyle.uri,
      super.createActionStyle = ActionStyle.uri,
      super.parentId});

  @override
  Widget buildListLayout(BuildContext context, ModelsState<T> listState,
      editState, bool fullScreen) {
    List<IAction> rtn = getItemActions(editState, fullScreen);

    return Scaffold(
        drawer: drawer,
        appBar: AppBar(
          actions: rtn
              .map((e) => IconButton(
                  onPressed: () => e.onSelected(context, editState.model),
                  icon: Icon(e.icon)))
              .toList(),
          title: Text(title ?? ""),
        ),
        body: super.buildListLayout(context, listState, editState, fullScreen));
    // });
  }
}
