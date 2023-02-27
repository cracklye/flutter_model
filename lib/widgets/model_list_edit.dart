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
      create: ((context) => ModelEditBloc<T>(
          RepositoryProvider.of<IModelAPI<T>>(context),
          RepositoryProvider.of<AttachmentDAO>(context),
          ModelEditStateNotLoaded<T>())),
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

        return buildStateLoaded(context, state as ModelsListLoaded<T>);
      } else {
        return Text("Loading");
      }
    });
  }

  Widget buildPrompt(Widget child) {
    return Container(
      color: Color(0x88AAAAAA),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
        child: m.Card(child: child),
      ),
    );
  }

  Widget buildStateLoaded(BuildContext context, ModelsListLoaded<T> state) {
    return BlocBuilder<ModelEditBloc<T>, ModelEditState<T>>(
      builder: (context, editstate) {
        if (editstate is ModelEditStateView<T>) {
          return buildPrompt(
              buildDetailDisplay(context, editstate, editstate.model));

          return buildDetailDisplay(context, editstate, editstate.model);
        } else if (editstate is ModelEditStateEdit<T>) {
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
    return ListTile(title: Text(model.displayLabel));
  }

  Widget buildList(BuildContext context, ModelsListState<T> state) {
    return Column(
      children: [
        Expanded(
            child: ModelExtendedListView<T>(
          buildListItem: buildListItem,
          enabledListTypes: const [ListViewType.list],
          onLongTap: ((model) => BlocProvider.of<ModelEditBloc<T>>(context)
              .add(ModelEditEventSelect<T>(model, false))),
        )),
        
        ElevatedButton(
            onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                  .add(ModelEditEventCreateNew<T>()),
            child: const Text("Create")),
      ],
    );
    return ModelExtendedListView<T>(
      buildListItem: buildListItem,
      enabledListTypes: const [ListViewType.list],
      onLongTap: ((model) => BlocProvider.of<ModelEditBloc<T>>(context)
          .add(ModelEditEventSelect<T>(model, false))),
    );
  }

  Widget buildDetail(BuildContext context, ModelsListState<T> state) {
    return BlocBuilder<ModelEditBloc<T>, ModelEditState<T>>(
      builder: buildDetailState,
    );
  }

  Widget buildDetailState(BuildContext context, ModelEditState<T> state) {
    if (state is ModelEditStateNotLoaded<T>) {
      return buildDetailNotSelected(context, state);
    } else if (state is ModelEditStateView<T>) {
      return buildDetailDisplay(context, state, state.model);
    } else if (state is ModelEditStateEdit<T>) {
      return buildDetailEdit(context, state, state.model);
    }
    return Text("Unhandled state: $state > ${state.model}");
  }

  Widget buildDetailNotSelected(
      BuildContext context, ModelEditStateNotLoaded<T> state) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildActionBar(context, [
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                  .add(ModelEditEventCreateNew<T>()),
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
      BuildContext context, ModelEditStateView<T> state, T? model) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildActionBar(context, [
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                  .add(ModelEditEventClear<T>()),
              child: const Text("Back")),
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                  .add(ModelEditEventCreateNew<T>()),
              child: const Text("Create")),
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                  .add(ModelEditEventMode<T>(true)),
              child: const Text("Edit")),
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                  .add(ModelEditEventDelete<T>()),
              child: const Text("Delete"))
        ]),
        //Text(state.selected != null ? state.selected!.id ?? "" : "No Id"),
        buildDetailDisplayForModel2(context, state, model)
      ],
    );
  }

  Widget buildDetailDisplayForModel2(
      BuildContext context, ModelEditStateView<T> state, T? model) {
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
      BuildContext context, ModelEditStateEdit<T> state, T? model) {
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
              onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                  .add(ModelEditEventMode<T>(false)),
              child: const Text("Cancel"))
        ]),
        buildForm2(
            context,
            state,
            model,
            formKey,
            (values) => BlocProvider.of<ModelEditBloc<T>>(context)
                .add(ModelEditEventSave<T>(values, isEditMode: false)))
      ],
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildForm2(
    BuildContext context,
    ModelEditStateEdit<T> state,
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
