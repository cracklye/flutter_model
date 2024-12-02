import 'package:extended_list_view/extended_list_view.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_events.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_view2.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_model/widgets/builder/model_list_builder.dart';
import 'package:flutter_model/widgets/builder/models_editview_builder.dart';
import 'package:loggy/loggy.dart';

class IAction<T> {
  final IconData icon;
  final String label;
  final Function(BuildContext context, T? model) onSelected;
  IAction({required this.icon, required this.label, required this.onSelected});
}

enum ActionStyle {
  dialog,
  uri,
  paneThenUri,
  paneThenDialog,
}

class ModelSinglePage<T extends IModel> extends StatelessWidget
    with //ModelListBlocAddin<T>,
        UiLoggy {
  final double splitMinWidthEdit = 400;
  final double splitListWidth = 400;
  final dynamic parentId;
  final bool enableSplit;
  final ActionStyle editActionStyle = ActionStyle.paneThenUri;

  ModelSinglePage({super.key, this.enableSplit = true, this.parentId});

  @override
  Widget build(BuildContext context) {
    return ModelListBlocWidget<T>(
        provideBloc: false,
        buildContent: (context, listState) => ModelEditViewBlocWidget<T>(
              provideBloc: true,
              // linkToListSelection: true,
              buildContent: (context, editState) =>
                  buildListBlocContent(context, listState, editState),
            ));
  }

  Widget buildListBlocContent(BuildContext context, ModelsState<T> listState,
      ModelEditViewState<T> editState) {
    return LayoutBuilder(builder: (context, size) {
      bool fullScreen = (splitMinWidthEdit == 0 ||
          size.maxWidth < (splitMinWidthEdit + splitListWidth));
      return buildListLayout(
          context, listState, editState, (!enableSplit) || fullScreen);
    });
  }

  Widget buildListLayout(BuildContext context, ModelsState<T> listState,
      ModelEditViewState<T> editState, bool fullScreen) {
    if (fullScreen) {
      return buildList(context, listState, editState, true);
    }

    const edge = EdgeInsets.fromLTRB(5, 0, 5, 0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: edge,
            child: SizedBox(
              width: splitListWidth,
              child: buildList(context, listState, editState, false),
            )),
        const VerticalDivider(),
        Expanded(
            child: Padding(
                padding: edge,
                child: SingleChildScrollView(
                    controller: ScrollController(),
                    //color: Colors.red,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: buildDetail(context, listState, editState)))))
      ],
    );
  }

  List<ListViewLayoutDefault<T>> getListDataProviders() {
    return [ListViewLayoutList(selectIcon: Icons.abc)];
  }

  List<ListViewOrderByItem> getOrderBy() {
    return [];
  }

  Widget buildList(BuildContext context, ModelsState<T> listState,
      ModelEditViewState<T> editState, bool isFullScreen) {
    bool isLoading = true;
    List<T> items = [];
    if (listState is ModelsLoaded<T>) {
      items = listState.models;
      isLoading = false;
    }

    return ExtendedListView<T>(
      listDataProviders: getListDataProviders(),
      selected:
          isFullScreen || editState.model == null ? [] : [editState.model!],
      isLoading: isLoading,
      items: items,

      orderBy: getOrderBy(),
      selectedOrderBy: listState.orderBy,
      onOrderByChange: (p) => BlocProvider.of<ModelsBloc<T>>(context)
          .add(ModelsChangeOrderBy<T>(p?.value)),

      onTap: (model) => _goDetail(context, model, isFullScreen),
      onDoubleTap: (model) => _goDetail(context, model, true),
      onSearchChange: (p0) => BlocProvider.of<ModelsBloc<T>>(context)
          .add(ModelsChangeSearchText<T>(p0)),

//TODO order by and filter by
      // onOrderByChange: (orderByItem) {
      //     BlocProvider.of<ModelsBloc<T>>(context)
      //     .add(ModelsChangeOrderBy<T>(orderByItem as List<SortOrderBy<T>>));
      // },
    );
  }

  void _goDetail(BuildContext context, T model, bool isFullScreen) {
    if (isFullScreen) {
      Navigator.of(context).pushNamed(ModelRouter.routeDetail<T>(model.id));
    } else {
      BlocProvider.of<ModelEditViewBloc<T>>(context)
          .add(ModelEditViewEventSelect<T>(model.id, false));
    }
  }

  void _goEdit(BuildContext context, T model, bool isFullScreen) {
    if (isFullScreen || editActionStyle == ActionStyle.uri) {
      Navigator.of(context).pushNamed(ModelRouter.routeEdit<T>(model.id));
    } else {
      BlocProvider.of<ModelEditViewBloc<T>>(context)
          .add(ModelEditViewEventMode<T>(true));
    }
  }

  void _goDelete(BuildContext context, T model, bool isFullScreen) {
    BlocProvider.of<ModelEditViewBloc<T>>(context)
        .add(ModelEditViewEventDelete<T>(model.id));
    if (isFullScreen) {
      //Context close
    }
  }

  void _goCancel(BuildContext context, bool isFullScreen) {
    BlocProvider.of<ModelEditViewBloc<T>>(context)
        .add(ModelEditViewEventMode<T>(false));
  }

  void _goSave(BuildContext context, bool isFullScreen) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }
  }

  void _goCreate(BuildContext context, bool isFullScreen) {
    if (isFullScreen || editActionStyle == ActionStyle.uri) {
      Navigator.of(context).pushNamed(ModelRouter.routeAdd<T>(parentId));
    } else {
      BlocProvider.of<ModelEditViewBloc<T>>(context)
          .add(ModelEditViewEventCreateNew<T>());
    }
  }

  Widget buildDetail(BuildContext context, ModelsState<T> listState,
      ModelEditViewState<T> editState) {
    if (editState is ModelEditViewStateNotLoaded<T>) {
      return buildDetailNotSelected(context, editState);
    } else if (editState is ModelEditViewStateLoaded<T>) {
      if (!editState.isEditMode) {
        return buildDetailDisplay(context, editState, editState.model);
      } else if (editState.isEditMode) {
        return buildDetailEdit(context, editState, editState.model);
      }
    }
    return Text("Unhandled state: $editState > ${editState.model}");
  }

  Widget buildDetailNotSelected(
      BuildContext context, ModelEditViewStateNotLoaded<T> state) {
    return const Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(""),
        )
      ],
    );
  }

  List<IAction> getItemActions(
      ModelEditViewState<T> editState, bool fullScreen) {
    List<IAction> rtn = [];
    if (fullScreen) {
      rtn.add(IAction(
        icon: Icons.add,
        label: 'Create',
        onSelected: (context, model) => _goCreate(context, fullScreen),
      ));
    } else {
      if (!editState.isEditMode) {
        rtn.add(IAction(
            icon: Icons.add,
            label: 'Create',
            onSelected: (context, model) => _goCreate(context, fullScreen)));

        rtn.add(IAction(
            icon: Icons.edit,
            label: 'Edit',
            onSelected: (context, model) =>
                _goEdit(context, model, fullScreen)));

        rtn.add(IAction(
            icon: Icons.delete,
            label: 'Delete',
            onSelected: (context, model) =>
                _goDelete(context, model, fullScreen)));
      } else if (editState is ModelEditViewStateNotLoaded<T>) {
        rtn.add(IAction(
          icon: Icons.add,
          label: 'Create',
          onSelected: (context, model) => _goCreate(context, fullScreen),
        ));
      } else if (editState.isEditMode) {
        rtn.add(IAction(
            icon: Icons.save,
            label: 'Save',
            onSelected: (context, model) => _goSave(context, fullScreen)));

        rtn.add(IAction(
            icon: Icons.cancel,
            label: 'Cancel',
            onSelected: (context, model) => _goCancel(context, fullScreen)));
      }
    }

    return rtn;
  }

  Widget buildDetailDisplay(
      BuildContext context, ModelEditViewStateLoaded<T> state, T? model) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [buildDetailDisplayForModel(context, state, model)],
    );
  }

  Widget buildDetailDisplayForModel(
      BuildContext context, ModelEditViewStateLoaded<T> state, T? model) {
    if (model == null) return const Text("Model is null");
    return Text(
        "Display page ${model.displayLabel} ID = ${model.id}  -  No Detail Page Provided");
  }

  Widget buildDetailEdit(
      BuildContext context, ModelEditViewStateLoaded<T> state, T? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildForm(
    BuildContext context,
    ModelEditViewStateLoaded<T> state,
    T? model,
    GlobalKey<FormState> formKey,
    void Function(Map<String, dynamic>) onSave,
  ) {
    return const Column(
      children: [
        Text("No form has been provided override the buildForm method"),
      ],
    );
  }
}
