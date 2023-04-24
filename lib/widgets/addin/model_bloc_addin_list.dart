part of flutter_model;

class ModelListBlocAddin<T extends IModel> {
  Widget buildListBlocProvider(BuildContext context, dynamic parentId) {
    return BlocProvider<ModelsListBloc<T>>(
        create: ((context) => ModelsListBloc<T>(
            modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
          ..add(ModelsListLoad<T>(
            parentId: parentId,
          ))),
        child: buildListBlocBuilder(context));
  }

  Widget buildListBlocBuilder(BuildContext context) {
    return BlocBuilder<ModelsListBloc<T>, ModelsListState<T>>(
      builder: (context, state) {
        //  return buildBlocLoaded(context, state);
        return buildListBlocContent(context, state);
      },
    );
  }

  Widget buildListBlocContent(BuildContext context, ModelsListState<T> state) {
    if (state is ModelsListLoaded<T>) {
      return buildListBlocLoaded(context, state);
    } else if (state is ModelsListLoading<T>) {
      return buildListBlocLoading(context, state);
    }
    if (state is ModelsListNotLoaded<T>) {
      return buildListBlocNotLoaded(context, state);
    }
    return Text("Unknown state: $state");
  }

  Widget buildListBlocLoaded(BuildContext context, ModelsListLoaded<T> state) {
    return Container();
  }

  Widget buildListBlocLoading(
      BuildContext context, ModelsListLoading<T> state) {
    return Text("Loading");
  }

  Widget buildListBlocNotLoaded(
      BuildContext context, ModelsListNotLoaded<T> state) {
    return Text("Not Loaded");
  }

  void doListChangeSearch(BuildContext context, String searchString) {
    BlocProvider.of<ModelsListBloc<T>>(context)
        .add(ModelsListChangeSearchText<T>(searchString));
  }

  void doListChangeOrderBy(
      BuildContext context, OrderByItem<T>? orderByChange) {
    BlocProvider.of<ModelsListBloc<T>>(context).add(ModelsListChangeOrderBy<T>(
        orderByChange != null ? orderByChange.getSortOrders() : null));
  }

  void doListChangeFilter(BuildContext context, FilterByItem<T>? filter) {
    BlocProvider.of<ModelsListBloc<T>>(context).add(
        ModelsListChangeFilter<T>(filter != null ? filter.getFilters() : null));
  }

  bool isListLoaded(ModelsListState<T> state) {
    if (state is ModelsListLoaded<T>) {
      return true;
    }
    return false;
  }

  bool isListLoading(ModelsListState<T> state) {
    if (state is ModelsListLoading<T>) {
      return true;
    }
    return false;
  }
}
