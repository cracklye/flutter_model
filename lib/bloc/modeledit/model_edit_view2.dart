import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_events.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

class ModelEditViewBloc<T extends IModel>
    extends Bloc<ModelEditViewEvent<T>, ModelEditViewState<T>>
    with UiLoggy, HandleAttachment<T> {
  final IModelAPI<T> dao;
  final AttachmentDAO? attachmentDao;

  ModelEditViewBloc(this.dao, this.attachmentDao,
      [super.initialState = const ModelEditViewStateNotLoaded()]) {
    on<ModelEditViewEventMode<T>>(_onModelEditViewEventMode);
    on<ModelEditViewEventSave<T>>(_onModelEditViewEventSave);
    on<ModelEditViewEventChanged<T>>(_onModelEditViewEventChanged);
    on<ModelEditViewEventSelect<T>>(_onModelEditViewEventSelect);
    on<ModelEditViewEventDelete<T>>(_onModelEditViewEventDelete);
    on<ModelEditViewEventCreateNew<T>>(_onModelEditViewEventCreateNew);
    on<ModelEditViewEventClear<T>>(_onModelEditViewEventClear);
    on<ModelEditViewEventSelectModel<T>>(_oModelEditViewEventSelectModel);
  }

  void _onModelEditViewEventClear(ModelEditViewEventClear<T> event,
      Emitter<ModelEditViewState<T>> emit) async {
    emit(ModelEditViewStateNotLoaded<T>());
  }
  

  void _onModelEditViewEventCreateNew(ModelEditViewEventCreateNew<T> event,
      Emitter<ModelEditViewState<T>> emit) async {
    emit(ModelEditViewStateLoaded<T>(isEditMode: true, isNewDoc: true));
  }

  void _onModelEditViewEventDelete(ModelEditViewEventDelete<T> event,
      Emitter<ModelEditViewState<T>> emit) async {
    await dao.deleteById(state.model!.id);
    emit(ModelEditViewStateNotLoaded<T>());
  }

  void _oModelEditViewEventSelectModel(ModelEditViewEventSelectModel<T> event,
      Emitter<ModelEditViewState<T>> emit) async {
    emit(ModelEditViewStateLoaded(
        model: event.model, isEditMode: event.isEditMode));
  }

  StreamSubscription? _modelsSubscription;

  void _onModelEditViewEventSelect(ModelEditViewEventSelect<T> event,
      Emitter<ModelEditViewState<T>> emit) async {
    //emit(ModelEditViewStateChanged<T>(state.model));
    _modelsSubscription?.cancel();

    emit(const ModelEditViewStateLoading());

    _modelsSubscription = (await dao.listById(event.id)).listen((model) {
      if (!isClosed) {
        loggy.debug(
            "_doLoadModels loading as _modelsSubscription has responded");
        add(ModelEditViewEventSelectModel<T>(model, event.isEditMode));
      }
    }); // TODO add the error handling back in .onError(() );
  }

  void _onModelEditViewEventChanged(ModelEditViewEventChanged<T> event,
      Emitter<ModelEditViewState<T>> emit) async {
    if (state is ModelEditViewStateLoaded<T>) {
      emit((state as ModelEditViewStateLoaded<T>).copyWith(isChanged: true));
    }
  }

  void _onModelEditViewEventMode(ModelEditViewEventMode<T> event,
      Emitter<ModelEditViewState<T>> emit) async {
    if (state is ModelEditViewStateLoaded<T>) {
      emit((state as ModelEditViewStateLoaded<T>)
          .copyWith(isEditMode: event.isEditMode));
    }
  }

  void _onModelEditViewEventSave(ModelEditViewEventSave<T> event,
      Emitter<ModelEditViewState<T>> emit) async {
    try {
      if (state is! ModelEditViewStateLoaded<T>) {
        return;
      }

//TODO need to update with ID and parent ID

      ModelEditViewStateLoaded<T> stateLoaded =
          state as ModelEditViewStateLoaded<T>;

      emit(stateLoaded.copyWith(isSaving: true));

      if (state.model == null) {
        // var newModel = await dao.create(event.values);
        var newModel = await doAddModel(
            dao, attachmentDao, event.values, loggy, event.deleteAttachment);

        emit(stateLoaded.copyWith(
            isSaved: true, model: newModel, isEditMode: event.isEditMode));
      } else {
        //await dao.update(state.model!.id, event.values);
        await doUpdateModel(dao, attachmentDao, state.model!.id, event.values,
            loggy, event.deleteAttachment);

        emit(stateLoaded.copyWith(
            isSaved: true, model: state.model, isEditMode: event.isEditMode));
      }
    } catch (e) {
      loggy.info(e);
      if (state is! ModelEditViewStateLoaded<T>) {
        emit((state as ModelEditViewStateLoaded<T>).copyWith(
            errorMessage: "Error saving the item ${e.toString()}",
            exception: e));
      }
    }
  }

  @override
  Future<void> close() async {
    await _modelsSubscription?.cancel();
    await super.close();
  }
}
