part of flutter_model;

class ModelsBloc<T extends IModel> extends Bloc<ModelsEvent<T>, ModelsState<T>>
    with UiLoggy {
  final IModelAPI<T> _modelsRepository;

  // final ModelsState<T> initState;

  StreamSubscription? _modelsSubscription;
  StreamSubscription? _parentBlocSubscription;

  ModelsBloc({
    required IModelAPI<T> modelsRepository,
    ModelsBloc? parentBloc,
  })  : _modelsRepository = modelsRepository,
        super(ModelsLoading<T>()) {
    if (parentBloc != null) {
      _parentBlocSubscription = parentBloc.stream.listen((stateB) {
         loggy.debug("_parentBlocSubscription.listen State $stateB");
        if (stateB is ModelsLoaded) {
          loggy.debug("_parentBlocSubscription.listen is is a models loaded");
          if (stateB.selected != null) {
            loggy.debug("_parentBlocSubscription.listen Selected is not null loading id: ${stateB.selected!.id}");
            add(LoadModels(parentId: stateB.selected!.id)); 
            return;
            
          }
        }
        add(LoadModels(clear: true));
      });
    }

    on<LoadModels<T>>(_onLoadModels);
    on<AddModel<T>>(_onAddModel);
    on<UpdateModel<T>>(_onUpdateModel);
    on<DeleteModel<T>>(_onDeleteModel);
    on<ModelsUpdated<T>>(_onModelsUpdated);
    on<CreateNewModel<T>>(_onCreateNewModel);
    on<UpdateSelected<T>>(_onUpdateSelected);
    on<UpdateModelValue<T>>(_onUpdateModelValue);
    on<RefreshLoadModel<T>>(_onRefreshLoadModel);

    on<ModelSelect<T>>(_onModelSelect);
  }
  void _onUpdateModelValue(
      UpdateModelValue<T> event, Emitter<ModelsState<T>> emit) async {
    var state2 = state as ModelsLoaded<T>;

    emit(state2.copyWith(selected: event.model));
  }

  void _onUpdateSelected(
      UpdateSelected<T> event, Emitter<ModelsState<T>> emit) async {
    var state2 = state as ModelsLoaded<T>;
    //var rtn = null;
    if (state2.selected != null && state2.selected!.id == null) {
      //var a =
      await _modelsRepository.createModel(state2.selected!);
      //  rtn = state2.selected!.copyWith(id: a);
    } else {
      //var a =
      await _modelsRepository.updateModel(state2.selected!);
      //  rtn = state2.selected!.copyWith(id: a);
    }

    emit(state2.copyWith(
      selected: null,
    ));
  }

  void _onCreateNewModel(
      CreateNewModel<T> event, Emitter<ModelsState<T>> emit) async {
    var state2 = state as ModelsLoaded<T>;

    emit(state2.copyWith(
        selected: _modelsRepository.createNewModel(),
        mode: ModelStateMode.edit));
  }

  void _onModelSelect(
      ModelSelect<T> event, Emitter<ModelsState<T>> emit) async {
    var state2 = state as ModelsLoaded<T>;

    emit(state2.copyWith(selected: event.model, mode: event.mode));
  }

  void _onLoadModels(LoadModels<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onLoadModels Returning models update $T");
    await _doLoadModels(event.parentId, event.id, emit, event.clear);
  }

  void _onAddModel(AddModel<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onAddModel Returning models update $T");
    _modelsRepository.create(event.values);
  }

  void _onUpdateModel(
      UpdateModel<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onUpdateModel Returning models update $T");
    _modelsRepository.update(event.id, event.values);
  }

  void _onDeleteModel(
      DeleteModel<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onDeleteModel Returning models update $T");
    _modelsRepository.deleteModel(event.model);
  }

  void _onModelsUpdated(
      ModelsUpdated<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onModelsUpdated Returning models update $T event");
    emit(ModelsLoading<T>());
    emit(ModelsLoaded<T>(models: event.models, id: event.id));

    loggy.debug("_onModelsUpdated Completed emit");
  }

  void _onRefreshLoadModel(
      RefreshLoadModel<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("ModelsBloc.mapRefreshLoadModelToState Existing $state");
    loggy.error("Missing the functionality for refreshing the modesl");
    //var st = state as RefreshLoadModel<T>;
    //TODO what do we do here...
    //await _doLoadModels(event.parentId, event.id, event.orderBy);
  }

  Future _doLoadModels(String? parentId, String? id,
      Emitter<ModelsState<T>> emit, bool clear) async {
    loggy.debug("_doLoadModels($parentId,$id) ");

    _modelsSubscription?.cancel();

    if (clear) {
       loggy.debug("_doLoadModels Clear is true so updating to empty list");
       
add(ModelsUpdated<T>(
                []));

    } else {
      if (id != null) {
        loggy.debug("_doLoadModels ID is not null");
        _modelsSubscription = _modelsRepository.listById(id).listen(
              (model) => add(ModelsUpdated<T>(
                [model!],
              )),
            );
      } else {
        loggy.debug("_doLoadModels ID is null");
        _modelsSubscription = _modelsRepository.list(parentId: parentId).listen(
          (models) {
            loggy.warning(
                "_doLoadModels, called the modesl subscription $models");
            loggy.warning("_doLoadModels, called the modesl subscription ");

            //We want to load

            loggy.debug("_doLoadModels loading");
            add(ModelsUpdated<T>(models));
          },
        );
      }
    }
  }

  @override
  Future<void> close() {
    _modelsSubscription?.cancel();
    if (_parentBlocSubscription != null) _parentBlocSubscription?.cancel();
    return super.close();
  }
}
