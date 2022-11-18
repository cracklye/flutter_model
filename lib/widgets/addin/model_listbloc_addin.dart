part of flutter_model;

class ModelListBlocAddin<T extends IModel> {
  Widget buildBlocProvider(BuildContext context, String parentId) {
    return BlocProvider<ModelsListBloc<T>>(
        create: ((context) => ModelsListBloc<T>(
            modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
          ..add(ModelsListLoad<T>(
            parentId: parentId,
          ))),
        child: buildBlocBuilder(context));
  }

  Widget buildBlocBuilder(BuildContext context) {
    return BlocBuilder<ModelsListBloc<T>, ModelsListState<T>>(
      builder: (context, state) {
        return buildBlocLoaded(context, state);

        // if (state is ModelsListLoaded<T>) {
        //   return buildBlocLoaded(context, state);
        // } else if (state is ModelsListLoading<T>) {
        //   return buildBlocLoading(context, state);
        // }
        // if (state is ModelsListNotLoaded<T>) {
        //   return buildBlocError(context, state);
        // }
        // return Text("Unknown state");
      },
    );
  }

  Widget buildBlocLoaded(BuildContext context, ModelsListState<T> state) {
    return Container();
  }
}

