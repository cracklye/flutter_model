part of flutter_model;

abstract class ModelEditState<T extends IModel> {
  final T? model;
  const ModelEditState([this.model]);
}

class ModelEditStateNotLoaded<T extends IModel> extends ModelEditState<T> {
  const ModelEditStateNotLoaded() : super(null);
}

class ModelEditStateEdit<T extends IModel> extends ModelEditState<T> {
  const ModelEditStateEdit([super.model]);
}

class ModelEditStateChanged<T extends IModel> extends ModelEditStateEdit<T> {
  const ModelEditStateChanged([super.model]);
}

class ModelEditStateSaving<T extends IModel> extends ModelEditStateEdit<T> {
  const ModelEditStateSaving([super.model]);
}

class ModelEditStateView<T extends IModel> extends ModelEditState<T> {
  const ModelEditStateView([super.model]);
}

class ModelEditStateError<T extends IModel> extends ModelEditState<T> {
  final dynamic e;
  final String message;
  const ModelEditStateError(this.message, [this.e, super.model]);
}

abstract class ModelEditEvent<T extends IModel> {
  const ModelEditEvent();
}

class ModelEditEventDelete<T extends IModel> extends ModelEditEvent<T> {
  const ModelEditEventDelete();
}

class ModelEditEventSave<T extends IModel> extends ModelEditEvent<T> {
  final Map<String, dynamic> values;
  final bool? isEditMode;

  const ModelEditEventSave(this.values, [this.isEditMode]);
}

class ModelEditEventChanged<T extends IModel> extends ModelEditEvent<T> {
  const ModelEditEventChanged();
}

class ModelEditEventCreateNew<T extends IModel> extends ModelEditEvent<T> {
  const ModelEditEventCreateNew();
}

class ModelEditEventMode<T extends IModel> extends ModelEditEvent<T> {
  final bool isEditMode;
  const ModelEditEventMode(this.isEditMode);
}

class ModelEditEventSelect<T extends IModel> extends ModelEditEvent<T> {
  final bool isEditMode;
  final T? model;

  const ModelEditEventSelect(this.model, this.isEditMode);
}

class ModelEditBloc<T extends IModel>
    extends Bloc<ModelEditEvent<T>, ModelEditState<T>> {
  IModelAPI<T> dao;

  ModelEditBloc(this.dao,
      [super.initialState = const ModelEditStateNotLoaded()]) {
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
    await dao.deleteById(state.model!.id);
    emit(ModelEditStateNotLoaded<T>());
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
