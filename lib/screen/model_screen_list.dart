import 'package:extended_list_view/extended_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_model/widgets/ui/page_header.dart';
import 'package:loggy/loggy.dart';

abstract class ModelScreenList<T extends IModel> extends ModelSinglePage<T>
    with UiLoggy {
  final Widget? drawer;
  final String? title;
  //final String? parentId;
  ModelScreenList({super.key, this.drawer, this.title, super.parentId});
  @override
  Widget buildDetailDisplay(
      BuildContext context, ModelEditViewStateView<T> state, T? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PageHeader(title: model?.displayLabel ?? "", actions: [
          IconButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventMode<T>(true)),
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventDelete<T>()),
              icon: const Icon(Icons.delete))
        ]),
        buildDetailDisplayForModel(context, state, model)
      ],
    );
  }

  @override
  Widget buildDetailEdit(
      BuildContext context, ModelEditViewStateEdit<T> state, T? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(title: "Edit", actions: [
          IconButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                }
              },
              icon: const Icon(Icons.save)),
          IconButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventMode<T>(false)),
              icon: const Icon(Icons.cancel))
        ]),
        buildForm(
            context,
            state,
            model,
            formKey,
            (values) => BlocProvider.of<ModelEditViewBloc<T>>(context)
                .add(ModelEditViewEventSave<T>(values, isEditMode: false)))
      ],
    );
  }

  List<ListViewOrderByItem> getOrderBy() {
    return [];
  }

  @override
  Widget buildListLayout(
      BuildContext context, ModelsListState<T> state, bool fullScreen) {
    return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
        builder: (context, editState) {
      List<Widget> rtn = [];
      if (fullScreen) {
        rtn.add(
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create',
            onPressed: () {
              Navigator.of(context).pushNamed(
                ModelRouter.routeAdd<T>(parentId),
              );
            },
          ),
        );
      } else {
        if (editState is ModelEditViewStateView<T>) {
          rtn.add(
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Create',
              onPressed: () {
                BlocProvider.of<ModelEditViewBloc<T>>(context)
                    .add(ModelEditViewEventCreateNew<T>());
              },
            ),
          );
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
              BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventMode<T>(true));
            },
          );

          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () {
              BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventDelete<T>());
            },
          );
        } else if (editState is ModelEditViewStateNotLoaded<T>) {
          IconButton(
            icon: const Icon(Icons.create),
            tooltip: 'Create',
            onPressed: () {
              BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventCreateNew<T>());
            },
          );
        } else if (editState is ModelEditViewStateEdit<T>) {
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
              }
            },
          );

          IconButton(
            icon: const Icon(Icons.cancel),
            tooltip: 'Cancel',
            onPressed: () {
              BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventMode<T>(false));
            },
          );
        }
      }
      return super.buildListLayout(context, state, fullScreen);
    });
  }
}
