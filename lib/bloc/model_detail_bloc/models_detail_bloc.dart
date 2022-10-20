part of flutter_model;

class ModelsDetailBloc<T extends IModel>
    extends Bloc<ModelsDetailEvent<T>, ModelsDetailState<T>> with UiLoggy {
  final IModelAPI<T> _modelsRepository;
  StreamSubscription? _modelsSubscription;

  ModelsDetailBloc({
    required IModelAPI<T> modelsRepository,
    ModelsBloc? parentBloc,
    ModelsDetailState<T>? initialState,
  })  : _modelsRepository = modelsRepository,
        super(initialState ?? ModelsDetailLoading<T>()) {
    on<ModelsDetailLoad<T>>(_onLoadModels);
    on<ModelsDetailDelete<T>>(_onDeleteModel);
    on<ModelsDetailUpdateDetail<T>>(_onModelsDetailUpdateDetail);
  }

  void _onModelsDetailUpdateDetail(ModelsDetailUpdateDetail<T> event,
      Emitter<ModelsDetailState<T>> emit) async {
    loggy.debug("_onModelsDetailUpdateDetail<$T> started with state $state");

    //emit(ModelsDetailLoading<T>.fromState(state));

    emit(ModelsDetailLoaded<T>.fromState(state, event.model));
  }

  void _onLoadModels(
      ModelsDetailLoad<T> event, Emitter<ModelsDetailState<T>> emit) async {
    loggy.debug("_onLoadModels Returning models update $T");
    _modelsSubscription?.cancel();
    emit(ModelsDetailLoading.fromState(state, id: event.id));

    loggy.debug("_doLoadModels ID is ${event.id}");

    _modelsSubscription =
        (await _modelsRepository.listById(event.id)).listen((model) {
      loggy.warning("_doLoadModels, called the modesl subscription ${model}");

      loggy.debug("_doLoadModels loading");
      if (model == null) {
        //TODO throw an exception..
      } else {
        add(ModelsDetailUpdateDetail<T>(model!));
      }
    });
  }

  void _onDeleteModel(
      ModelsDetailDelete<T> event, Emitter<ModelsDetailState<T>> emit) async {
    loggy.debug("_onDeleteModel Returning models update $T");
    _modelsRepository.deleteModel(event.model);
    emit(ModelDeleted(id: state.id));
  }

  @override
  Future<void> close() {
    _modelsSubscription?.cancel();

    return super.close();
  }
}
