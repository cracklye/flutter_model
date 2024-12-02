import 'package:extended_list_view/extended_list_view.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_events.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_view2.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

// import 'package:woue_components/woue_components.dart';

class ModelSinglePage<T extends IModel> extends StatelessWidget
    with ModelListBlocAddin<T>, UiLoggy {
  final double splitMinWidthEdit = 400;
  final double splitListWidth = 400;
  final dynamic parentId;
  final bool enableSplit;

  ModelSinglePage({super.key, this.enableSplit = true, this.parentId});

  @override
  Widget build(BuildContext context) {





    
    return buildBlocProviderEdit(context);
  }

  Widget buildBlocProviderEdit(BuildContext context) {
    AttachmentDAO? attachDao;
    try {
      attachDao = RepositoryProvider.of<AttachmentDAO>(context);
    } catch (e) {
      loggy.info("Unable to get the AttachmenDAO from context $e");
    }

    return BlocProvider(
        create: ((context) => ModelEditViewBloc<T>(
            RepositoryProvider.of<IModelAPI<T>>(context),
            attachDao,
            ModelEditViewStateNotLoaded<T>())),
        child: buildListBlocProvider(context, parentId));
  }

  @override
  Widget buildListBlocContent(BuildContext context, ModelsState<T> state) {
    return LayoutBuilder(builder: (context, size) {
      bool fullScreen = (splitMinWidthEdit == 0 ||
          size.maxWidth < (splitMinWidthEdit + splitListWidth));
      return buildListLayout(context, state, (!enableSplit) || fullScreen);
    });
  }

  Widget buildListLayout(
      BuildContext context, ModelsState<T> state, bool fullScreen) {
    if (fullScreen) {
      return buildList(context, state, true);
    }

    const edge = EdgeInsets.fromLTRB(5, 0, 5, 0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: edge,
            child: SizedBox(
              width: splitListWidth,
              child: buildList(context, state, false),
            )),
        Expanded(
            child: Padding(
                padding: edge,
                child: SingleChildScrollView(
                    controller: ScrollController(),
                    //color: Colors.red,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: buildDetail(context, state)))))
      ],
    );
  }

  List<ListViewLayoutDefault<T>> getListDataProviders() {
    return [ListViewLayoutList(selectIcon: m.Icons.abc)];
  }

  List<ListViewOrderByItem> getOrderBy() {
    return [];
  }

  Widget buildList(
      BuildContext context, ModelsState<T> state, bool isFullScreen) {
    bool isLoading = true;
    List<T> items = [];
    if (state is ModelsLoaded<T>) {
      items = state.models;
      isLoading = false;
    }

    return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
        builder: (context, editState) {
      return ExtendedListView<T>(
        listDataProviders: getListDataProviders(),
        selected:
            isFullScreen || editState.model == null ? [] : [editState.model!],
        isLoading: isLoading,
        items: items,

        orderBy: getOrderBy(),
        selectedOrderBy: state.orderBy,
        onOrderByChange: (p) => BlocProvider.of<ModelsBloc<T>>(context)
            .add(ModelsChangeOrderBy<T>(p?.value)),

        onTap: isFullScreen
            ? ((model) => Navigator.of(context)
                .pushNamed(ModelRouter.routeDetail<T>(model.id)))
            : ((model) => BlocProvider.of<ModelEditViewBloc<T>>(context)
                .add(ModelEditViewEventSelect<T>(model, false))),
        onSearchChange: (p0) => BlocProvider.of<ModelsBloc<T>>(context)
            .add(ModelsChangeSearchText<T>(p0)),

//TODO order by and filter by
        // onOrderByChange: (orderByItem) {
        //     BlocProvider.of<ModelsBloc<T>>(context)
        //     .add(ModelsChangeOrderBy<T>(orderByItem as List<SortOrderBy<T>>));
        // },
      );
    });
  }

  Widget buildDetail(BuildContext context, ModelsState<T> state) {
    return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
        builder:
            buildDetailState //(context, state) => Text("This is the buidler $state"),
        );
  }

  Widget buildDetailState(BuildContext context, ModelEditViewState<T> state) {
    if (state is ModelEditViewStateNotLoaded<T>) {
      return buildDetailNotSelected(context, state);
    } else if (state is ModelEditViewStateLoaded<T>) {
      if (!state.isEditMode) {
        return buildDetailDisplay(context, state, state.model);
      } else if (state.isEditMode) {
        return buildDetailEdit(context, state, state.model);
      }
    }
    return Text("Unhandled state: $state > ${state.model}");
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
