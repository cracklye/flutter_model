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
}

class ModelSinglePage<T extends IModel> extends StatelessWidget
    with //ModelListBlocAddin<T>,
        UiLoggy {
  final double splitMinWidthEdit = 400;
  final double splitListWidth = 400;
  final dynamic parentId;
  final bool enableSplit;

  final ActionStyle editActionStyle;
  final ActionStyle displayActionStyle;
  final ActionStyle createActionStyle;

  ModelSinglePage({
    super.key,
    this.enableSplit = true,
    this.parentId,
    this.editActionStyle = ActionStyle.uri,
    this.displayActionStyle = ActionStyle.uri,
    this.createActionStyle = ActionStyle.uri,
  });

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
                child:
                    // SingleChildScrollView(
                    //     controller: ScrollController(),
                    //     //color: Colors.red,
                    //     child: Padding(
                    //         padding: const EdgeInsets.only(top: 20),
                    //         child:
                    buildDetail(context, listState, editState))
            //  ))
            )
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
      buildToolbar: buildToolbar,
      buildToolbarFooter: buildToobarFooter,
      buildToolbarLeading: buildToolbarLeading,
      buildToolbarSub: buildToolbarSub,
      buildViewIcons: buildViewIcons,
      footerText: footerText,
      selectedFilterBy: getFilterBy(),
      listDataProviders: getListDataProviders(),
      selected:
          isFullScreen || editState.model == null ? [] : [editState.model!],
      isLoading: isLoading,
      items: items,
      orderBy: getOrderBy(),
      selectedOrderBy: listState.orderBy,
      onOrderByChange: (p) => BlocProvider.of<ModelsBloc<T>>(context)
          .add(ModelsChangeOrderBy<T>(p?.value)),
      onTap: (model) => goDetail(context, model, isFullScreen),
      onDoubleTap: (model) => goDetail(context, model, true),
      onSearchChange: (p0) => BlocProvider.of<ModelsBloc<T>>(context)
          .add(ModelsChangeSearchText<T>(p0)),
      onSearchClear: (p0) => BlocProvider.of<ModelsBloc<T>>(context)
          .add(ModelsChangeSearchText<T>("")),
      onLongTap: (p0) => onLongTap(context, p0),
      // onFilterByChange: (p0) {
      //   BlocProvider.of<ModelsBloc<T>>(context)
      //       .add(ModelsChangeFilter<T>(p0)
      //       );
      // }
    );
  }

  List<dynamic>? getFilterBy() {
    return null;
  }

  void onLongTap(BuildContext context, T? model) {}

  Widget Function(BuildContext)? get buildToolbar => null;
  Widget Function(BuildContext)? get buildToobarFooter => null;
  Widget Function(BuildContext)? get buildToolbarLeading => null;
  Widget Function(BuildContext)? get buildToolbarSub => null;
  List<Widget> Function(BuildContext)? get buildViewIcons => null;

  String get footerText => "";

  void goDetail(BuildContext context, T model, bool isFullScreen) {
    if (!isFullScreen) {
      BlocProvider.of<ModelEditViewBloc<T>>(context)
          .add(ModelEditViewEventSelect<T>(model.id, false));
    } else if (createActionStyle == ActionStyle.dialog) {
      ModelDialog<T>(buildDisplay: buildDetailDisplayForModel).showDetail(
        context,
        model,
        formKey,
        (p0, p1, p2) => goEdit(context, model, isFullScreen),
      );
    } else {
      Navigator.of(context).pushNamed(ModelRouter.routeDetail<T>(model.id));
    }
  }

  void goEdit(BuildContext context, T model, bool isFullScreen) {
    if (!isFullScreen) {
      BlocProvider.of<ModelEditViewBloc<T>>(context)
          .add(ModelEditViewEventMode<T>(true));
    } else if (editActionStyle == ActionStyle.dialog) {
      ModelDialog<T>(buildForm: buildForm).showAdd(context, formKey, model);
    } else {
      Navigator.of(context).pushNamed(ModelRouter.routeEdit<T>(model.id));
    }
  }

  void goDelete(BuildContext context, T model, bool isFullScreen) {
    BlocProvider.of<ModelEditViewBloc<T>>(context)
        .add(ModelEditViewEventDelete<T>(model.id));
    if (isFullScreen) {
      //Context close
    }
  }

  void goCancel(BuildContext context, bool isFullScreen) {
    BlocProvider.of<ModelEditViewBloc<T>>(context)
        .add(ModelEditViewEventMode<T>(false));
  }

  void goSave(BuildContext context, bool isFullScreen) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }
  }

  void goCreate(BuildContext context, bool isFullScreen) {
    if (!isFullScreen) {
      BlocProvider.of<ModelEditViewBloc<T>>(context)
          .add(ModelEditViewEventCreateNew<T>());
    } else if (createActionStyle == ActionStyle.dialog) {
      ModelDialog<T>(buildForm: buildForm).showAdd(context, formKey);
    } else {
      Navigator.of(context).pushNamed(ModelRouter.routeAdd<T>(parentId));
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
    if (editState is ModelEditViewStateLoaded<T>) {
      if (fullScreen) {
        rtn.add(IAction(
          icon: Icons.add,
          label: 'Create',
          onSelected: (context, model) => goCreate(context, fullScreen),
        ));
      } else {
        if (!editState.isEditMode) {
          rtn.add(IAction(
              icon: Icons.add,
              label: 'Create',
              onSelected: (context, model) => goCreate(context, fullScreen)));

          rtn.add(IAction(
              icon: Icons.edit,
              label: 'Edit',
              onSelected: (context, model) =>
                  goEdit(context, model, fullScreen)));

          rtn.add(IAction(
              icon: Icons.delete,
              label: 'Delete',
              onSelected: (context, model) =>
                  goDelete(context, model, fullScreen)));
        } else if (editState is ModelEditViewStateNotLoaded<T>) {
          rtn.add(IAction(
            icon: Icons.add,
            label: 'Create',
            onSelected: (context, model) => goCreate(context, fullScreen),
          ));
        } else if (editState.isEditMode) {
          rtn.add(IAction(
              icon: Icons.save,
              label: 'Save',
              onSelected: (context, model) => goSave(context, fullScreen)));

          rtn.add(IAction(
              icon: Icons.cancel,
              label: 'Cancel',
              onSelected: (context, model) => goCancel(context, fullScreen)));
        }
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
