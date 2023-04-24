part of flutter_model;

class ModelListEdit<T extends IModel> extends StatelessWidget {
  ModelListEdit({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildBlocProvider(context);
  }

  Widget buildBlocProvider(BuildContext context) {
    return BlocProvider(
      create: ((context) => ModelsListBloc(
          modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
        ..add(ModelsListLoad(
            orderBy: [SortOrderByFieldName("_name", "name", true)]))),
      child: buildBlocProviderEdit(context),
    );
  }

  Widget buildBlocProviderEdit(BuildContext context) {
    return BlocProvider(
      create: ((context) => ModelEditViewBloc<T>(
          RepositoryProvider.of<IModelAPI<T>>(context),
          RepositoryProvider.of<AttachmentDAO>(context),
          ModelEditViewStateNotLoaded<T>())),
      child: buildBlocBuilder(context),
    );
  }

  Widget buildBlocBuilder(BuildContext context) {
    return BlocBuilder<ModelsListBloc<T>, ModelsListState<T>>(
        builder: (context, state) {
      if (state is ModelsListLoaded<T>) {
        return Stack(
          children: [
            buildList(context, state),
            buildStateLoaded(context, state),
          ],
        );
      } else {
        return const Text("Loading");
      }
    });
  }

  Widget buildPrompt(Widget child) {
    return Container(
      color: const Color(0x88AAAAAA),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
        child: m.Card(child: child),
      ),
    );
  }

  Widget buildStateLoaded(BuildContext context, ModelsListLoaded<T> state) {
    return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
      builder: (context, editstate) {
        if (editstate is ModelEditViewStateView<T>) {
          return buildPrompt(
              buildDetailDisplay(context, editstate, editstate.model));
        } else if (editstate is ModelEditViewStateEdit<T>) {
          return buildPrompt(
              buildDetailEdit(context, editstate, editstate.model));
        }

        return Container();
      },
    );
  }

  Widget buildListHeader(BuildContext context, ModelsListState<T> state) {
    return SizedBox(
      height: 30, 
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ElevatedButton(
            onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
                .add(CreateNewModel<T>()),
            child: const Text("Create")),
      ]),
    );
  }

  Widget buildListItem(BuildContext context, T model, Function()? onTap,
      Function()? onDoubleTap, Function()? onLongPress) {
//return null;
    return ListTile(
      title: Text(model.displayLabel),
      onTap: onTap,
      onDoubleTap: onDoubleTap,
    );
  }

  Widget buildList(BuildContext context, ModelsListState<T> state) {
    return Column(
      children: [
        Expanded(
            child: ModelExtendedListView<T>(
          buildListItem: buildListItem,
          enabledListTypes: const [ListViewType.list],
          onTap: ((model) => BlocProvider.of<ModelEditViewBloc<T>>(context)
              .add(ModelEditViewEventSelect<T>(model, false))),
        )),
        ElevatedButton(
            onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                .add(ModelEditViewEventCreateNew<T>()),
            child: const Text("Create")),
      ],
    );
  }

  Widget buildDetail(BuildContext context, ModelsListState<T> state) {
    return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
      builder: buildDetailState,
    );
  }

  Widget buildDetailState(BuildContext context, ModelEditViewState<T> state) {
    if (state is ModelEditViewStateNotLoaded<T>) {
      return buildDetailNotSelected(context, state);
    } else if (state is ModelEditViewStateView<T>) {
      return buildDetailDisplay(context, state, state.model);
    } else if (state is ModelEditViewStateEdit<T>) {
      return buildDetailEdit(context, state, state.model);
    }
    return Text("Unhandled state: $state > ${state.model}");
  }

  Widget buildDetailNotSelected(
      BuildContext context, ModelEditViewStateNotLoaded<T> state) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildActionBar(context, [
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventCreateNew<T>()),
              child: const Text("Create")),
        ]),
        //Text(state.selected != null ? state.selected!.id ?? "" : "No Id"),
        const Center(
          child: Text(""),
        )
      ],
    );
  }

  Widget buildDetailDisplay(
      BuildContext context, ModelEditViewStateView<T> state, T? model) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildActionBar(context, [
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventClear<T>()),
              child: const Text("Back")),
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventCreateNew<T>()),
              child: const Text("Create")),
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventMode<T>(true)),
              child: const Text("Edit")),
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventDelete<T>()),
              child: const Text("Delete"))
        ]),
        //Text(state.selected != null ? state.selected!.id ?? "" : "No Id"),
        buildDetailDisplayForModel2(context, state, model)
      ],
    );
  }

  Widget buildDetailDisplayForModel2(
      BuildContext context, ModelEditViewStateView<T> state, T? model) {
    if (model == null) return const Text("Model is null");
    return Text(
        "Display page ${model.displayLabel} ID = ${model.id}  -  No Detail Page Provided");
  }

  Widget buildActionBar(BuildContext context, List<Widget> actions) {
    return SizedBox(
        height: 30,
        child: Row(
          children: actions,
        ));
  }

  Widget buildDetailEdit(
      BuildContext context, ModelEditViewStateEdit<T> state, T? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildActionBar(context, [
          ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                }
              },
              child: const Text("Save")),
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventMode<T>(false)),
              child: const Text("Cancel"))
        ]),
        buildForm2(
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

  Widget buildForm2(
    BuildContext context,
    ModelEditViewStateEdit<T> state,
    T? model,
    GlobalKey<FormState> formKey,
    void Function(Map<String, dynamic>) onSave,
  ) {
    return Column(
      children: const [
        Text("No form has been provided"),
      ],
    );
  }
}
