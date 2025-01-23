import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_events.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_view2.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_model/widgets/builder/models_editview_builder.dart';

class ModelScreenDetail<T extends IModel> extends StatelessWidget {
  final dynamic id;
  final Function(BuildContext context)? onDeleted;

  const ModelScreenDetail({
    required this.id,
    this.onDeleted,
    super.key,
  });

  List<IAction> getActions(BuildContext context, ModelEditViewState<T> state) {
    // IconButton(
    //               icon: const Icon(Icons.edit),
    //               tooltip: 'Edit',
    //               onPressed: () {
    //                 Navigator.of(context).pushNamed(ModelRouter.routeEdit<T>(
    //                     (state as ModelEditViewStateLoaded<T>).model!.id));
    //               },
    //             ),
    //             IconButton(
    //               icon: const Icon(Icons.delete),
    //               tooltip: 'Delete',
    //               onPressed: () {
    //                 doDelete(context,
    //                     (state as ModelEditViewStateLoaded<T>).model!);
    //               },
    //             ),
    //             IconButton(
    //               icon: const Icon(Icons.close),
    //               tooltip: 'Close',
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             ),

    if (state is! ModelEditViewStateLoaded<T>) {
      return [];
    }

    return [
      IAction(
        icon: Icons.edit,
        label: "Edit",
        onSelected: (context, model) {
          Navigator.of(context).pushNamed(ModelRouter.routeEdit<T>(
              (state).model!.id));
        },
      ),
      IAction(
        icon: Icons.delete,
        label: "Delete",
        onSelected: (context, model) {
          doDelete(context, (state).model!);
        },
      ),
      IAction(
        icon: Icons.close,
        label: "Close",
        onSelected: (context, model) {
          Navigator.of(context).pop();
        },
      ),
    ];
  }

  Widget getPageTitle(BuildContext context, ModelEditViewState state) {
    if (state.isEditMode) {
      return const Text("Edit");
    }

    if (state.model != null) {
      return Text(state.model!.displayLabel);
    } else {
      return const Text("Edit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModelEditViewBlocWidget<T>(
        id: id,
        initialEvent:  ModelEditViewEventClear<T>(),
        provideBloc: true,
        buildScaffold: (context, state, content) => Scaffold(
              body: content(context, state),
              appBar: AppBar(
                  centerTitle: false,
                  title: getPageTitle(context, state),
                  actions: getActions(context, state)
                      .map((e) => IconButton(
                            onPressed:()=> e.onSelected(context, state.model),
                            icon: Icon(e.icon),
                            tooltip: e.label,
                          ))
                      .toList()),
            ),
        buildContent: (context, state) =>
            buildDetailBlocContent(context, state));

    // return buildDetailBlocProvider(context, id, onDeleted);
  }

  void doDelete(BuildContext context, T model) {
    BlocProvider.of<ModelEditViewBloc<T>>(context)
        .add(ModelEditViewEventDelete<T>(model.id));
  }

  Widget buildDetailBlocContent(
      BuildContext context, ModelEditViewState<T> state) {
    return const Text("Builder for content is not provided");
  }
}
