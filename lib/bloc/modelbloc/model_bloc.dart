import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

class ModelsBloc<T extends IModel> extends Bloc<ModelsEvent<T>, ModelsState<T>>
    with UiLoggy, HandleAttachment<T> {
  final IModelAPI<T> _modelsRepository;

  // final ModelsState<T> initState;

  StreamSubscription? _modelsSubscription;
  StreamSubscription? _parentBlocSubscription;
  final AttachmentDAO? attachmentDao;

  ModelsBloc({
    required IModelAPI<T> modelsRepository,
    ModelsBloc? parentBloc,
    this.attachmentDao,
  })  : _modelsRepository = modelsRepository,
        super(ModelsLoading<T>()) {
    if (parentBloc != null) {
      _parentBlocSubscription = parentBloc.stream.listen((stateB) {
        loggy.debug("_parentBlocSubscription.listen State ");
        if (stateB is ModelsLoaded) {
          loggy.debug("_parentBlocSubscription.listen is is a models loaded");
          if ((stateB as ModelsLoaded).selected != null) {
            loggy.debug(
                "_parentBlocSubscription.listen Selected is not null loading id: ${(stateB as ModelsLoaded).selected!.id}");
            add(LoadModels(parentId: (stateB as ModelsLoaded).selected!.id));
            return;
          }
        }
        add(const LoadModels(clear: true));
      });
    }

    on<LoadModels<T>>(_onLoadModels);
    on<AddModel<T>>(_onAddModel);
    on<UpdateModel<T>>(_onUpdateModel);
    on<DeleteModel<T>>(_onDeleteModel);
    on<ModelsUpdated<T>>(_onModelsUpdated);
    on<CreateNewModel<T>>(_onCreateNewModel);
    on<UpdateSelected<T>>(_onUpdateSelected);
    //on<UpdateModelValue<T>>(_onUpdateModelValue);
    on<RefreshLoadModel<T>>(_onRefreshLoadModel);
    on<SetEditMode<T>>(_onSetEditMode);
    on<ModelSelect<T>>(_onModelSelect);
    on<ModelsDeleteAttachment<T>>(_onModelsDeleteAttachment);
  }

  void _onModelsDeleteAttachment(
      ModelsDeleteAttachment<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug(
        "_onModelsDeleteAttachment<$T> started ${event.id} ${event.fieldName}");

    if (attachmentDao != null) {
      await attachmentDao!.removeContentPost(event.fieldName, event.id);
    } else {
      loggy.error("RmeoveAttachment event sent by attachmentDAO is null");
    }
  }

  void _onSetEditMode(
      SetEditMode<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onSetEditMode<$T> started ${event.editMode}");
    var state2 = state as ModelsLoaded<T>;
    if (event.editMode) {
      emit(state2.copyWith(mode: ModelStateMode.edit));
    } else {
      emit(state2.copyWith(mode: ModelStateMode.view));
    }
  }

  // void _onUpdateModelValue(
  //     UpdateModelValue<T> event, Emitter<ModelsState<T>> emit) async {
  //   var state2 = state as ModelsLoaded<T>;
  //   emit(state2.copyWith(selected: event.model));
  // }

  /// Saves the selected model that is in the state.  (if the id is null then it creates a new model, if
  /// not then the matching model is updated)
  void _onUpdateSelected(
      UpdateSelected<T> event, Emitter<ModelsState<T>> emit) async {
    var state2 = state as ModelsLoaded<T>;
    if (state2.selected != null && state2.selected!.id == null) {
      await _modelsRepository.createModel(state2.selected!);
    } else {
      await _modelsRepository.updateModel(state2.selected!);
    }

    emit(state2.copyWith(
      selected: null,
    ));
  }

  /// Creates a new empty model and sets it to the state.selected property
  void _onCreateNewModel(
      CreateNewModel<T> event, Emitter<ModelsState<T>> emit) async {
    var state2 = state as ModelsLoaded<T>;

    emit(state2.copyWith(
        selected: _modelsRepository.createNewModel(),
        mode: ModelStateMode.edit));
  }

  void _onModelSelect(
      ModelSelect<T> event, Emitter<ModelsState<T>> emit) async {
    if (state is ModelsLoaded<T>) {
      var state2 = state as ModelsLoaded<T>;
      loggy.debug("_onModelSelect select model  $T");
      if (event.model == null) {
        emit(ModelsLoaded<T>(
            id: state2.id,
            models: state2.models,
            hierarchy: state2.hierarchy,
            parameters: state2.parameters));
      } else {
        emit(state2.copyWith(selected: event.model, mode: event.mode));
      }
    }
  }

  void _onLoadModels(LoadModels<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onLoadModels Returning models update $T $event");
    await _doLoadModels(event.parentId, event.id, emit, event.clear);
  }

  void _onAddModel(AddModel<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onAddModel Returning models update $T (${event.editMode})");

    var values = event.values;

    var newModel = await doAddModel(_modelsRepository, attachmentDao, values,
        loggy, event.deleteAttachment);

    add(ModelSelect(newModel, ModelStateMode.edit));
  }

  void _onUpdateModel(
      UpdateModel<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onUpdateModel Returning models update $T");
    var values = event.values;

    await doUpdateModel(_modelsRepository, attachmentDao, event.id, values,
        loggy, event.deleteAttachment);
  }

  void _onDeleteModel(
      DeleteModel<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onDeleteModel Returning models update $T");
    _modelsRepository.deleteModel(event.model);
  }

  void _onModelsUpdated(
      ModelsUpdated<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug(
        "_onModelsUpdated Returning models update $T count: ${event.models.length} $event ");
    //Selected...
    T? selectedModel;

    if (state is ModelsLoaded<T>) {
      var state2 = state as ModelsLoaded<T>;
      var selected = state2.selected;
      if (selected != null) {
        selectedModel = await _modelsRepository.getById(selected.id);
      }
    }

    emit(ModelsLoading<T>());
    List<HierarchyEntry<T>> hierarchy = [];

    //Compute the hierarchy...
    if (event.models.isNotEmpty && event.models[0] is IHierarchy) {
      //
      hierarchy = HierarchyHelper.computeHierarchy(event.models);
    }

    emit(ModelsLoaded<T>(
        models: event.models,
        id: event.id,
        selected: selectedModel,
        hierarchy: hierarchy));

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

      add(ModelsUpdated<T>([]));
    } else {
      if (id != null) {
        loggy.debug("_doLoadModels ID is not null");
        _modelsSubscription = (await _modelsRepository.listById(id)).listen(
          (model) => add(ModelsUpdated<T>(
            [model!],
          )),
        );
      } else {
        loggy.debug("_doLoadModels ID is null $parentId");
        _modelsSubscription =
            (await _modelsRepository.list(parentId: parentId)).listen(
          (models) {
            loggy.debug(
                "_doLoadModels, called the modesl subscription ${models.length}");
            loggy.debug(
                "_doLoadModels, called the modesl subscription $parentId");

            //We want to load

            loggy.debug("_doLoadModels loading");
            add(ModelsUpdated<T>(models));
          },
        );
      }
    }
  }

  @override
  Future<void> close() async {
    await _modelsSubscription?.cancel();
    await _parentBlocSubscription?.cancel();
    await super.close();
  }
}
