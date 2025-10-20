import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

class ModelsBloc<T extends IModel> extends Bloc<ModelsEvent<T>, ModelsState<T>>
    with UiLoggy, HandleAttachment<T> {
  final IModelAPI<T> modelsRepository;
  StreamSubscription? _modelsSubscription;
  // final ModelsState<T> initState;

  StreamSubscription? _parentBlocSubscription;
  final AttachmentDAO? attachmentDao;

  ModelsBloc({
    required this.modelsRepository,
    ModelsBloc? parentBloc,
    this.attachmentDao,
    ModelsState<T>? initialState,
  }) : //_modelsRepository = modelsRepository,
        super(initialState ?? ModelsLoading<T>()) {
    if (parentBloc != null) {
      _parentBlocSubscription = parentBloc.stream.listen((stateB) {
        loggy.debug("_parentBlocSubscription.listen State ");
        if (stateB is ModelsLoaded) {
          loggy.debug("_parentBlocSubscription.listen is is a models loaded");
          if ((stateB).selected != null) {
            loggy.debug(
                "_parentBlocSubscription.listen Selected is not null loading id: ${(stateB).selected!.first.id}");
            add(ModelsLoad(parentId: (stateB).selected!.first.id)
                // state.copyWith()
                );
            return;
          }
        }
        add(const ModelsUpdateList([]));
      });
    }

    on<ModelsLoad<T>>(_onLoadModels);
    on<ModelsDelete<T>>(_onDeleteModel);
    on<ModelSelect<T>>(_onModelSelect);
    on<ModelsUpdateList<T>>(_onModelsUpdateList);
    on<ModelsChangeSearchText<T>>(_onModelsChangeSearchText);
    on<ModelsChangeOrderBy<T>>(_onModelsChangeOrderBy);
    on<ModelsChangeFilter<T>>(_onModelsChangeFilter);

    on<AddModel<T>>(_onAddModel);
    on<UpdateModel<T>>(_onUpdateModel);
    // on<CreateNewModel<T>>(_onCreateNewModel);
    on<ModelsDeleteAttachment<T>>(_onModelsDeleteAttachment);
  }

  void _onModelsChangeSearchText(
      ModelsChangeSearchText<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onModelsChangeSearchText<$T> started }");
    loggy.debug("_onModelsChangeSearchText<$T> state= $state");
    add(ModelsLoad<T>(
      parentId: state.parentId,
      filters: state.filters,
      orderBy: state.orderBy,
      searchtext: event.searchText,
    ));
  }

  void _onModelsChangeOrderBy(
      ModelsChangeOrderBy<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onModelsChangeOrderBy<$T> started }");

    add(ModelsLoad<T>(
      parentId: state.parentId,
      filters: state.filters,
      orderBy: event.sortOrders,
      searchtext: state.searchText,
    ));
  }

  void _onModelsChangeFilter(
      ModelsChangeFilter<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onModelsChangeFilter<$T> started }");

    add(ModelsLoad<T>(
      parentId: state.parentId,
      filters: event.filters,
      orderBy: state.orderBy,
      searchtext: state.searchText,
    ));
  }

  void _onModelsUpdateList(
      ModelsUpdateList<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onModelsUpdateList<$T> started with state $state");

    //Check the state....
    // if(state is ModelsLoaded<T>){
    //   emit(state.copyWith(models:event.models));
    // }

    emit(ModelsLoading<T>.fromState(state));

    List<HierarchyEntry<T>> hierarchy = [];

    //Compute the hierarchy...
    if (event.models.isNotEmpty && event.models[0] is IHierarchy) {
      //
      hierarchy = HierarchyHelper.computeHierarchy(event.models);
    }

    print("** Replacing the state");
    List<T>? selected;
    if (state.selected != null) {
      selected = [];
      for (var itm in state.selected!) {
        try {
          T fnd = event.models.firstWhere((e) => e.id == itm.id);
          selected.add(fnd);
        } catch (e) {
          print("** Replacing the state $e");
        }
      }
    }

    emit(ModelsLoaded<T>.fromState(state,
        hierarchy: hierarchy, models: event.models, selected: selected));
  }

  void _onModelSelect(
      ModelSelect<T> event, Emitter<ModelsState<T>> emit) async {
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
        if (state is ModelsLoaded<T> &&
            (state as ModelsLoaded<T>).selected != null) {
          selected = (state as ModelsLoaded<T>).selected!;
        }
        selected.add(event.model!);
      }
    }

    emit(ModelsLoaded<T>.fromState(state, selected: selected));
  }

  void _onLoadModels(ModelsLoad<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onLoadModels Returning models update $T");
    _modelsSubscription?.cancel();

    emit(ModelsLoading.fromState(state,
        parentId: event.parentId,
        searchText: event.searchtext,
        orderBy: event.orderBy,
        filters: event.filters));

    if (event.clear) {
      loggy.debug("_doLoadModels Clear is true so updating to empty list");

      add(ModelsUpdateList<T>([]));
    } else {
      loggy.debug("_doLoadModels ID is null ${event.parentId}");
      _modelsSubscription = (await modelsRepository.list(
              parentId: event.parentId,
              searchText: event.searchtext,
              orderBy: event.orderBy,
              filters: event.filters))
          .listen(
        (models) {
          // loggy.warning(
          //     "_doLoadModels, called the modesl subscription ${models.length}");
          // loggy.warning(
          //     "_doLoadModels, called the modesl subscription $event.parentId");

          //We want to load
          if (!isClosed) {
            loggy.debug(
                "_doLoadModels loading as _modelsSubscription has responded");
            add(ModelsUpdateList<T>(models));
          }
        },
      );
    }
  }

  void _onDeleteModel(
      ModelsDelete<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onDeleteModel Returning models update $T");
    modelsRepository.deleteModel(event.model);
  }

  /// Saves the selected model that is in the state.  (if the id is null then it creates a new model, if
  /// not then the matching model is updated)
// void _onUpdateSelected(
//     UpdateSelected<T> event, Emitter<ModelsState<T>> emit) async {
//   var state2 = state as ModelsLoaded<T>;
//   if (state2.selected != null && state2.selected!.id == null) {
//     await modelsRepository.createModel(state2.selected!);
//   } else {
//     await modelsRepository.updateModel(state2.selected!);
//   }

//   emit(state2.copyWith(
//     selected: null,
//   ));
// }

  /// Creates a new empty model and sets it to the state.selected property
// void _onCreateNewModel(
//     CreateNewModel<T> event, Emitter<ModelsState<T>> emit) async {
//   var state2 = state as ModelsLoaded<T>;

//   emit(state2.copyWith(
//       selected: _modelsRepository.createNewModel(),
//        mode: ModelStateMode.edit));
// }

  void _onAddModel(AddModel<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onAddModel Returning models update $T (${event.editMode})");

    var values = event.values;

    var newModel = await doAddModel(
        modelsRepository, attachmentDao, values, loggy, event.deleteAttachment);

    // add(ModelSelect(newModel, ModelStateMode.edit));
  }

  void _onUpdateModel(
      UpdateModel<T> event, Emitter<ModelsState<T>> emit) async {
    loggy.debug("_onUpdateModel Returning models update $T");
    var values = event.values;

    await doUpdateModel(modelsRepository, attachmentDao, event.id, values,
        loggy, event.deleteAttachment);

    // print("***** UPDATED *****");
    // if (state.selected != null && state is ModelsLoaded<T>) {
    //   int idx = state.selected!.indexWhere((e) => e.id == event.id);
    //   if (idx != -1) {
    //     //Replace the state
    //     var stateSelect = [...state.selected!];
    //     var mdl = await modelsRepository.getById(event.id);
    //     if (mdl != null) {
    //       stateSelect[idx] = mdl;
    //       emit((state as ModelsLoaded<T>).copyWith(selected: stateSelect));
    //     }
    //   }
    // }
  }

  @override
  Future<void> close() async {
    await _modelsSubscription?.cancel();
    await super.close();
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
}

// void _onDeleteModel(DeleteModel<T> event, Emitter<ModelsState<T>> emit) async {
//   loggy.debug("_onDeleteModel Returning models update $T");
//   _modelsRepository.deleteModel(event.model);
// }

// void _onModelsUpdated(
//     ModelsUpdated<T> event, Emitter<ModelsState<T>> emit) async {
//   loggy.debug(
//       "_onModelsUpdated Returning models update $T count: ${event.models.length} $event ");
//   //Selected...
//   T? selectedModel;

//   if (state is ModelsLoaded<T>) {
//     var state2 = state as ModelsLoaded<T>;
//     var selected = state2.selected;
//     if (selected != null) {
//       selectedModel = await _modelsRepository.getById(selected.id);
//     }
//   }

//   emit(ModelsLoading<T>());
//   List<HierarchyEntry<T>> hierarchy = [];

//   //Compute the hierarchy...
//   if (event.models.isNotEmpty && event.models[0] is IHierarchy) {
//     //
//     hierarchy = HierarchyHelper.computeHierarchy(event.models);
//   }

//   emit(ModelsLoaded<T>(
//       models: event.models,
//       id: event.id,
//       selected: selectedModel,
//       hierarchy: hierarchy));

//   loggy.debug("_onModelsUpdated Completed emit");
// }

// void _onRefreshLoadModel(
//     RefreshLoadModel<T> event, Emitter<ModelsState<T>> emit) async {
//   loggy.debug("ModelsBloc.mapRefreshLoadModelToState Existing $state");
//   loggy.error("Missing the functionality for refreshing the modesl");
//   //var st = state as RefreshLoadModel<T>;
//   //TODO what do we do here...
//   //await _doLoadModels(event.parentId, event.id, event.orderBy);
// }

// Future _doLoadModels(String? parentId, String? id, Emitter<ModelsState<T>> emit,
//     bool clear) async {
//   loggy.debug("_doLoadModels($parentId,$id) ");

//   _modelsSubscription?.cancel();

//   if (clear) {
//     loggy.debug("_doLoadModels Clear is true so updating to empty list");

//     add(ModelsUpdated<T>([]));
//   } else {
//     if (id != null) {
//       loggy.debug("_doLoadModels ID is not null");
//       _modelsSubscription = (await _modelsRepository.listById(id)).listen(
//         (model) => add(ModelsUpdated<T>(
//           [model!],
//         )),
//       );
//     } else {
//       loggy.debug("_doLoadModels ID is null $parentId");
//       _modelsSubscription =
//           (await _modelsRepository.list(parentId: parentId)).listen(
//         (models) {
//           loggy.debug(
//               "_doLoadModels, called the modesl subscription ${models.length}");
//           loggy
//               .debug("_doLoadModels, called the modesl subscription $parentId");

//           //We want to load

//           loggy.debug("_doLoadModels loading");
//           add(ModelsUpdated<T>(models));
//         },
//       );
//     }
//   }
// }

// class ModelsBloc<T extends IModel> extends Bloc<ModelsEvent<T>, ModelsState<T>>
//     with UiLoggy, HandleAttachment<T> {
//   final IModelAPI<T> modelsRepository;

//   // final ModelsState<T> initState;

//   StreamSubscription? modelsSubscription;
//   StreamSubscription? parentBlocSubscription;
//   final AttachmentDAO? attachmentDao;

//   ModelsBloc({
//     required IModelAPI<T> modelsRepository,
//     ModelsBloc? parentBloc,
//     this.attachmentDao,
//   })  : modelsRepository = modelsRepository,
//         super(ModelsLoading<T>()) {
//     if (parentBloc != null) {
//       parentBlocSubscription = parentBloc.stream.listen((stateB) {
//         loggy.debug("_parentBlocSubscription.listen State ");
//         if (stateB is ModelsLoaded) {
//           loggy.debug("_parentBlocSubscription.listen is is a models loaded");
//           if ((stateB).selected != null) {
//             loggy.debug(
//                 "_parentBlocSubscription.listen Selected is not null loading id: ${(stateB).selected!.id}");
//             add(LoadModels(parentId: (stateB).selected!.id));
//             return;
//           }
//         }
//         add(const LoadModels(clear: true));
//       });
//     }

//     on<LoadModels<T>>(onLoadModels);
//     on<DeleteModel<T>>(onDeleteModel);
//     on<ModelsUpdated<T>>(onModelsUpdated);

//     on<UpdateSelected<T>>(onUpdateSelected);
//     //on<UpdateModelValue<T>>(_onUpdateModelValue);
//     on<RefreshLoadModel<T>>(onRefreshLoadModel);
//     on<SetEditMode<T>>(onSetEditMode);
//     on<ModelSelect<T>>(onModelSelect);
//   }

//   void onModelsDeleteAttachment(
//       ModelsDeleteAttachment<T> event, Emitter<ModelsState<T>> emit) async {
//     loggy.debug(
//         "_onModelsDeleteAttachment<$T> started ${event.id} ${event.fieldName}");

//     loggy.error("RmeoveAttachment event sent by attachmentDAO is null");
//     }

//   void onSetEditMode(
//       SetEditMode<T> event, Emitter<ModelsState<T>> emit) async {
//     loggy.debug("_onSetEditMode<$T> started ${event.editMode}");
//     var state2 = state as ModelsLoaded<T>;
//     if (event.editMode) {
//       emit(state2.copyWith(mode: ModelStateMode.edit));
//     } else {
//       emit(state2.copyWith(mode: ModelStateMode.view));
//     }
//   }

//   // void _onUpdateModelValue(
//   //     UpdateModelValue<T> event, Emitter<ModelsState<T>> emit) async {
//   //   var state2 = state as ModelsLoaded<T>;
//   //   emit(state2.copyWith(selected: event.model));
//   // }

//   /// Saves the selected model that is in the state.  (if the id is null then it creates a new model, if
//   /// not then the matching model is updated)
//   void onUpdateSelected(
//       UpdateSelected<T> event, Emitter<ModelsState<T>> emit) async {
//     var state2 = state as ModelsLoaded<T>;
//     if (state2.selected != null && state2.selected!.id == null) {
//       await modelsRepository.createModel(state2.selected!);
//     } else {
//       await modelsRepository.updateModel(state2.selected!);
//     }

//     emit(state2.copyWith(
//       selected: null,
//     ));
//   }

//   /// Creates a new empty model and sets it to the state.selected property
//   void onCreateNewModel(
//       CreateNewModel<T> event, Emitter<ModelsState<T>> emit) async {
//     var state2 = state as ModelsLoaded<T>;

//     emit(state2.copyWith(
//         selected: modelsRepository.createNewModel(),
//         mode: ModelStateMode.edit));
//   }

//   void onModelSelect(
//       ModelSelect<T> event, Emitter<ModelsState<T>> emit) async {
//     if (state is ModelsLoaded<T>) {
//       var state2 = state as ModelsLoaded<T>;
//       loggy.debug("_onModelSelect select model  $T");
//       if (event.model == null) {
//         emit(ModelsLoaded<T>(
//             id: state2.id,
//             models: state2.models,
//             hierarchy: state2.hierarchy,
//             parameters: state2.parameters));
//       } else {
//         emit(state2.copyWith(selected: event.model, mode: event.mode));
//       }
//     }
//   }

//   void onLoadModels(LoadModels<T> event, Emitter<ModelsState<T>> emit) async {
//     loggy.debug("_onLoadModels Returning models update $T $event");
//     await doLoadModels(event.parentId, event.id, emit, event.clear);
//   }

// void onAddModel(AddModel<T> event, Emitter<ModelsState<T>> emit) async {
//   loggy.debug("_onAddModel Returning models update $T (${event.editMode})");

//   var values = event.values;

//   var newModel = await doAddModel(
//       modelsRepository, attachmentDao, values, loggy, event.deleteAttachment);

//   add(ModelSelect(newModel, ModelStateMode.edit));
// }

// void onUpdateModel(UpdateModel<T> event, Emitter<ModelsState<T>> emit) async {
//   loggy.debug("_onUpdateModel Returning models update $T");
//   var values = event.values;

//   await doUpdateModel(modelsRepository, attachmentDao, event.id, values, loggy,
//       event.deleteAttachment);
// }

// void onDeleteModel(DeleteModel<T> event, Emitter<ModelsState<T>> emit) async {
//   loggy.debug("_onDeleteModel Returning models update $T");
//   modelsRepository.deleteModel(event.model);
// }

//   void onModelsUpdated(
//       ModelsUpdated<T> event, Emitter<ModelsState<T>> emit) async {
//     loggy.debug(
//         "_onModelsUpdated Returning models update $T count: ${event.models.length} $event ");
//     //Selected...
//     T? selectedModel;

//     if (state is ModelsLoaded<T>) {
//       var state2 = state as ModelsLoaded<T>;
//       var selected = state2.selected;
//       if (selected != null) {
//         selectedModel = await modelsRepository.getById(selected.id);
//       }
//     }

//     emit(ModelsLoading<T>());
//     List<HierarchyEntry<T>> hierarchy = [];

//     //Compute the hierarchy...
//     if (event.models.isNotEmpty && event.models[0] is IHierarchy) {
//       //
//       hierarchy = HierarchyHelper.computeHierarchy(event.models);
//     }

//     emit(ModelsLoaded<T>(
//         models: event.models,
//         id: event.id,
//         selected: selectedModel,
//         hierarchy: hierarchy));

//     loggy.debug("_onModelsUpdated Completed emit");
//   }

//   void onRefreshLoadModel(
//       RefreshLoadModel<T> event, Emitter<ModelsState<T>> emit) async {
//     loggy.debug("ModelsBloc.mapRefreshLoadModelToState Existing $state");
//     loggy.error("Missing the functionality for refreshing the modesl");
//     //var st = state as RefreshLoadModel<T>;
//     //TODO what do we do here...
//     //await _doLoadModels(event.parentId, event.id, event.orderBy);
//   }

//   Future doLoadModels(String? parentId, String? id,
//       Emitter<ModelsState<T>> emit, bool clear) async {
//     loggy.debug("_doLoadModels($parentId,$id) ");

//     modelsSubscription?.cancel();

//     if (clear) {
//       loggy.debug("_doLoadModels Clear is true so updating to empty list");

//       add(ModelsUpdated<T>([]));
//     } else {
//       if (id != null) {
//         loggy.debug("_doLoadModels ID is not null");
//         modelsSubscription = (await modelsRepository.listById(id)).listen(
//           (model) => add(ModelsUpdated<T>(
//             [model!],
//           )),
//         );
//       } else {
//         loggy.debug("_doLoadModels ID is null $parentId");
//         modelsSubscription =
//             (await modelsRepository.list(parentId: parentId)).listen(
//           (models) {
//             loggy.debug(
//                 "_doLoadModels, called the modesl subscription ${models.length}");
//             loggy.debug(
//                 "_doLoadModels, called the modesl subscription $parentId");

//             //We want to load

//             loggy.debug("_doLoadModels loading");
//             add(ModelsUpdated<T>(models));
//           },
//         );
//       }
//     }
//   }

//   @override
//   Future<void> close() async {
//     await modelsSubscription?.cancel();
//     await parentBlocSubscription?.cancel();
//     await super.close();
//   }
// }
