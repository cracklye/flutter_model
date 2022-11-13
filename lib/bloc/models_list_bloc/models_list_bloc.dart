part of flutter_model;

class ModelsListBloc<T extends IModel>
    extends Bloc<ModelsListEvent<T>, ModelsListState<T>> with UiLoggy {
  final IModelAPI<T> modelsRepository;
  StreamSubscription? _modelsSubscription;

  ModelsListBloc({
    required this.modelsRepository,
    //ModelsBloc? parentBloc,
    ModelsListState<T>? initialState, 
  })  : //_modelsRepository = modelsRepository,
        super(initialState??ModelsListLoading<T>()) {

    on<ModelsListLoad<T>>(_onLoadModels);
    on<ModelsListDelete<T>>(_onDeleteModel);
    on<ModelListSelect<T>>(_onModelSelect);
    on<ModelsListUpdateList<T>>(_onModelsListUpdateList);
    on<ModelsListChangeSearchText<T>>(_onModelsListChangeSearchText);
    on<ModelsListChangeOrderBy<T>>(_onModelsListChangeOrderBy);
    on<ModelsListChangeFilter<T>>(_onModelsListChangeFilter);

  }

  void _onModelsListChangeSearchText(ModelsListChangeSearchText<T> event,
      Emitter<ModelsListState<T>> emit) async {
    loggy.debug("_onModelsListChangeSearchText<$T> started }");
    loggy.debug("_onModelsListChangeSearchText<$T> state= $state");
    add(ModelsListLoad<T>(
      parentId: state.parentId,
      filters: state.filters,
      orderBy: state.orderBy,
      searchtext: event.searchText,
    ));
  }

  void _onModelsListChangeOrderBy(ModelsListChangeOrderBy<T> event,
      Emitter<ModelsListState<T>> emit) async {
    loggy.debug("_onModelsListChangeOrderBy<$T> started }");

    add(ModelsListLoad<T>(
      parentId: state.parentId,
      filters: state.filters,
      orderBy: event.sortOrders,
      searchtext: state.searchText,
    ));
  }

  void _onModelsListChangeFilter(
      ModelsListChangeFilter<T> event, Emitter<ModelsListState<T>> emit) async {
    loggy.debug("_onModelsListChangeFilter<$T> started }");

    add(ModelsListLoad<T>(
      parentId: state.parentId,
      filters: event.filters,
      orderBy: state.orderBy,
      searchtext: state.searchText,
    ));
  }

  void _onModelsListUpdateList(
      ModelsListUpdateList<T> event, Emitter<ModelsListState<T>> emit) async {
    loggy.debug("_onModelsListUpdateList<$T> started with state $state");

    //Check the state....
    // if(state is ModelsListLoaded<T>){
    //   emit(state.copyWith(models:event.models));
    // }

    emit(ModelsListLoading<T>.fromState(state));
    
    List<HierarchyEntry<T>> hierarchy = [];

    //Compute the hierarchy...
    if (event.models.isNotEmpty && event.models[0] is IHierarchy) {
      //
      hierarchy = HierarchyHelper.computeHierarchy(event.models);
    }

    emit(ModelsListLoaded<T>.fromState(state,
        hierarchy: hierarchy, models: event.models));
  }

  void _onModelSelect(
      ModelListSelect<T> event, Emitter<ModelsListState<T>> emit) async {
    loggy.debug("_onModelSelect select model ${event.model} $T");

    List<T> selected = [];

    if (!event.appendToSelection) {
      if (event.model != null) {
        selected = [event.model!];
      } else {
        selected = [];
      }
    } else {
      if (event.model != null) {
        if (state is ModelsListLoaded<T> &&
            (state as ModelsListLoaded<T>).selected != null) {
          selected = (state as ModelsListLoaded<T>).selected!;
        }
        selected.add(event.model!);
      }
    }

    emit(ModelsListLoaded<T>.fromState(state, selected: selected));
  }

  void _onLoadModels(
      ModelsListLoad<T> event, Emitter<ModelsListState<T>> emit) async {
    loggy.debug("_onLoadModels Returning models update $T");
    _modelsSubscription?.cancel();

    emit(ModelsListLoading.fromState(state, parentId: event.parentId,
              searchText: event.searchtext,
              orderBy: event.orderBy,
              filters: event.filters ));

              
    if (event.clear) {
      loggy.debug("_doLoadModels Clear is true so updating to empty list");

      add(ModelsListUpdateList<T>([]));

    } else {
      loggy.debug("_doLoadModels ID is null ${event.parentId}");
      _modelsSubscription = (await modelsRepository.list(
              parentId: event.parentId,
              searchText: event.searchtext,
              orderBy: event.orderBy,
              filters: event.filters))
          .listen(
        (models) {
          loggy.warning(
              "_doLoadModels, called the modesl subscription ${models.length}");
          loggy.warning(
              "_doLoadModels, called the modesl subscription $event.parentId");

          //We want to load

          loggy.debug("_doLoadModels loading");
          add(ModelsListUpdateList<T>(models));

        },
      );
    }
  }

  void _onDeleteModel(
      ModelsListDelete<T> event, Emitter<ModelsListState<T>> emit) async {
    loggy.debug("_onDeleteModel Returning models update $T");
    modelsRepository.deleteModel(event.model);
  }

  @override
  Future<void> close() {
    _modelsSubscription?.cancel();

    return super.close();
  }
}
