import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

/// This bloc can be used to return the information
/// for a single model based on the ID.  It also allows for the
/// deletion of that model by passing in the ID.
///
class ModelsDetailBloc<T extends IModel>
    extends Bloc<ModelsDetailEvent<T>, ModelsDetailState<T>> with UiLoggy {
  final IModelAPI<T> modelsRepository;
  StreamSubscription? _modelsSubscription;

  /// Constructor, sets the starting state to [initialState] and sets the repoistory to use to [modelsRepository]
  ///
  ModelsDetailBloc({
    required this.modelsRepository,
    //ModelsBloc? parentBloc,
    ModelsDetailState<T>? initialState,
  }) : super(initialState ?? ModelsDetailNotLoaded<T>()) {
    on<ModelsDetailLoad<T>>(_onLoadModels);
    on<ModelsDetailDelete<T>>(_onDeleteModel);
    on<ModelsDetailUpdateDetail<T>>(_onModelsDetailUpdateDetail);
    on<ModelDetailRaiseError<T>>(_onModelDetailRaiseError);
  }

  /// Handles an error message, this is mainly used within internal methods
  /// and sets the state to [ModelsDetailError]
  void _onModelDetailRaiseError(ModelDetailRaiseError<T> event,
      Emitter<ModelsDetailState<T>> emit) async {
    loggy.debug("_onModelDetailRaiseError<$T> started with state $state");

    emit(ModelsDetailError<T>.fromState(state, event.message));
  }

  /// Updates the selected model detail as a result of the query.
  void _onModelsDetailUpdateDetail(ModelsDetailUpdateDetail<T> event,
      Emitter<ModelsDetailState<T>> emit) async {
    loggy.debug("_onModelsDetailUpdateDetail<$T> started with state $state");

    emit(ModelsDetailLoaded<T>.fromState(state, event.model));
  }

  /// Handles the request to select a model.  If the event.id is null then will add an ModelsDetailError event
  void _onLoadModels(
      ModelsDetailLoad<T> event, Emitter<ModelsDetailState<T>> emit) async {
    loggy.debug("_onLoadModels Returning models update $T");
    _modelsSubscription?.cancel();

    if (event.id == null) {
      //Throw an error
      emit(ModelsDetailError<T>(
          errorMessage:
              'the ID provided is null, unable to retrieve model information'));
      return;
    }

    emit(ModelsDetailLoading.fromState(state, id: event.id));

    loggy.debug("_doLoadModels ID is ${event.id}");

    _modelsSubscription =
        (await modelsRepository.listById(event.id)).listen((model) {
      loggy.warning("_doLoadModels, called the models subscription so loading");
      if (!isClosed) {
        if (model == null) {
          add(const ModelDetailRaiseError("no model returned"));
        } else {
          add(ModelsDetailUpdateDetail<T>(model));
        }
      }
    });
  }

  /// Handkes the request to delete the model.
  void _onDeleteModel(
      ModelsDetailDelete<T> event, Emitter<ModelsDetailState<T>> emit) async {
    loggy.debug("_onDeleteModel Returning models update $T");
    if (event.id == null) {
      emit(ModelsDetailError<T>(
          errorMessage: "No event ID provided, unable to delete"));
      return;
    }
    modelsRepository.deleteById(event.id);
    emit(ModelDeleted(id: event.id));
  }

  /// Closes the models subscription if it is not null.
  @override
  Future<void> close() async {
    await _modelsSubscription?.cancel();

    await super.close();
  }
}
