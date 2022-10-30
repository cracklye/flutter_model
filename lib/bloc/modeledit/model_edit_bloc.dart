part of flutter_model;

abstract class ModelEditState<T extends IModel> {
  T? model;
  ModelEditState([this.model]);
}

class ModelEditStateNotLoaded<T extends IModel> extends ModelEditState<T> {
  ModelEditStateNotLoaded() : super(null);
}

class ModelEditStateEdit<T extends IModel> extends ModelEditState<T> {
  ModelEditStateEdit([super.model]);
}

class ModelEditStateChanged<T extends IModel> extends ModelEditStateEdit<T> {
  ModelEditStateChanged([super.model]);
}

class ModelEditStateSaving<T extends IModel> extends ModelEditStateEdit<T> {
  ModelEditStateSaving([super.model]);
}

class ModelEditStateView<T extends IModel> extends ModelEditState<T> {
  ModelEditStateView([super.model]);
}

class ModelEditStateError<T extends IModel> extends ModelEditState<T> {
  final dynamic e;
  final String message;
  ModelEditStateError(this.message, [this.e, super.model]);
}

abstract class ModelEditEvent<T extends IModel> {}

class ModelEditEventDelete<T extends IModel> extends ModelEditEvent<T> {
  ModelEditEventDelete();
}

class ModelEditEventSave<T extends IModel> extends ModelEditEvent<T> {
  final Map<String, dynamic> values;
  final bool? isEditMode;

  ModelEditEventSave(this.values, [this.isEditMode]);
}

class ModelEditEventChanged<T extends IModel> extends ModelEditEvent<T> {}

class ModelEditEventCreateNew<T extends IModel> extends ModelEditEvent<T> {}

class ModelEditEventMode<T extends IModel> extends ModelEditEvent<T> {
  final bool isEditMode;
  ModelEditEventMode(this.isEditMode);
}

class ModelEditEventSelect<T extends IModel> extends ModelEditEvent<T> {
  final bool isEditMode;
  final T? model;

  ModelEditEventSelect(this.model, this.isEditMode);
}

class ModelEditBloc<T extends IModel>
    extends Bloc<ModelEditEvent<T>, ModelEditState<T>> {
  IModelAPI<T> dao;

  ModelEditBloc(this.dao, super.initialState) {
    on<ModelEditEventMode<T>>(_onModelEditEventMode);
    on<ModelEditEventSave<T>>(_onModelEditEventSave);
    on<ModelEditEventChanged<T>>(_onModelEditEventChanged);
    on<ModelEditEventSelect<T>>(_onModelEditEventSelect);
    on<ModelEditEventDelete<T>>(_onModelEditEventDelete);
    on<ModelEditEventCreateNew<T>>(_onModelEditEventCreateNew);
  }

  void _onModelEditEventCreateNew(
      ModelEditEventCreateNew<T> event, Emitter<ModelEditState<T>> emit) async {
    emit(ModelEditStateEdit<T>(
      null,
    ));
  }

  void _onModelEditEventDelete(
      ModelEditEventDelete<T> event, Emitter<ModelEditState<T>> emit) async {
    await dao.deleteModel(state.model!);
    emit(ModelEditStateNotLoaded());
  }

  void _onModelEditEventSelect(
      ModelEditEventSelect<T> event, Emitter<ModelEditState<T>> emit) async {
    //emit(ModelEditStateChanged<T>(state.model));
    if (event.isEditMode) {
      emit(ModelEditStateEdit<T>(
        event.model,
      ));
    } else {
      emit(ModelEditStateView<T>(event.model));
    }
  }

  void _onModelEditEventChanged(
      ModelEditEventChanged<T> event, Emitter<ModelEditState<T>> emit) async {
    emit(ModelEditStateChanged<T>(state.model));
  }

  void _onModelEditEventMode(
      ModelEditEventMode<T> event, Emitter<ModelEditState<T>> emit) async {
    if (event.isEditMode) {
      emit(ModelEditStateEdit<T>(state.model));
    } else {
      emit(ModelEditStateView<T>(state.model));
    }
  }

  void _onModelEditEventSave(
      ModelEditEventSave<T> event, Emitter<ModelEditState<T>> emit) async {
    try {
      emit(ModelEditStateSaving<T>(state.model));
      if (state.model == null) {
        var newModel = await dao.create(event.values);
        emit(ModelEditStateEdit<T>(newModel));
      } else {
        await dao.update(state.model!.id, event.values);
        emit(ModelEditStateEdit<T>(state.model));
      }
      if (event.isEditMode != null) {
        add(ModelEditEventMode(event.isEditMode!));
      }
    } catch (e) {
      print(e);
      emit(ModelEditStateError<T>(
          "Error saving the item ${e.toString()}", e, state.model));
    }
  }
}
