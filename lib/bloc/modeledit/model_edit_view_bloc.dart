part of flutter_model;

abstract class ModelEditViewState<T extends IModel> {
  final T? model;
  const ModelEditViewState([this.model]);
}

class ModelEditViewStateNotLoaded<T extends IModel> extends ModelEditViewState<T> {
  const ModelEditViewStateNotLoaded() : super(null);
}

class ModelEditViewStateEdit<T extends IModel> extends ModelEditViewState<T> {
  const ModelEditViewStateEdit([super.model]);
}

class ModelEditViewStateChanged<T extends IModel> extends ModelEditViewStateEdit<T> {
  const ModelEditViewStateChanged([super.model]);
}

class ModelEditViewStateSaving<T extends IModel> extends ModelEditViewStateEdit<T> {
  const ModelEditViewStateSaving([super.model]);
}

class ModelEditViewStateView<T extends IModel> extends ModelEditViewState<T> {
  const ModelEditViewStateView([super.model]);
}

class ModelEditViewStateError<T extends IModel> extends ModelEditViewState<T> {
  final dynamic e;
  final String message;
  const ModelEditViewStateError(this.message, [this.e, super.model]);
}

abstract class ModelEditViewEvent<T extends IModel> {
  const ModelEditViewEvent();
}

class ModelEditViewEventDelete<T extends IModel> extends ModelEditViewEvent<T> {
  const ModelEditViewEventDelete();
}

class ModelEditViewEventClear<T extends IModel> extends ModelEditViewEvent<T> {
  const ModelEditViewEventClear();
}

class ModelEditViewEventSave<T extends IModel> extends ModelEditViewEvent<T> {
  final Map<String, dynamic> values;
  final bool? isEditMode;
  final bool deleteAttachment;

  const ModelEditViewEventSave(this.values,
      {this.isEditMode, this.deleteAttachment = false});
}

class ModelEditViewEventChanged<T extends IModel> extends ModelEditViewEvent<T> {
  const ModelEditViewEventChanged();
}

class ModelEditViewEventCreateNew<T extends IModel> extends ModelEditViewEvent<T> {
  const ModelEditViewEventCreateNew();
}

class ModelEditViewEventMode<T extends IModel> extends ModelEditViewEvent<T> {
  final bool isEditMode;
  const ModelEditViewEventMode(this.isEditMode);
}

class ModelEditViewEventSelect<T extends IModel> extends ModelEditViewEvent<T> {
  final bool isEditMode;
  final T? model;

  const ModelEditViewEventSelect(this.model, this.isEditMode);
}

class ModelEditViewBloc<T extends IModel>
    extends Bloc<ModelEditViewEvent<T>, ModelEditViewState<T>>
    with UiLoggy, HandleAttachment<T> {
  IModelAPI<T> dao;
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
  }

  void _onModelEditViewEventClear(
      ModelEditViewEventClear<T> event, Emitter<ModelEditViewState<T>> emit) async {
    emit(ModelEditViewStateNotLoaded<T>());
  }

  void _onModelEditViewEventCreateNew(
      ModelEditViewEventCreateNew<T> event, Emitter<ModelEditViewState<T>> emit) async {
    emit(ModelEditViewStateEdit<T>(
      null,
    ));
  }

  void _onModelEditViewEventDelete(
      ModelEditViewEventDelete<T> event, Emitter<ModelEditViewState<T>> emit) async {
    await dao.deleteById(state.model!.id);
    emit(ModelEditViewStateNotLoaded<T>());
  }

  void _onModelEditViewEventSelect(
      ModelEditViewEventSelect<T> event, Emitter<ModelEditViewState<T>> emit) async {
    //emit(ModelEditViewStateChanged<T>(state.model));
    if (event.isEditMode) {
      emit(ModelEditViewStateEdit<T>(
        event.model,
      ));
    } else {
      emit(ModelEditViewStateView<T>(event.model));
    }
  }

  void _onModelEditViewEventChanged(
      ModelEditViewEventChanged<T> event, Emitter<ModelEditViewState<T>> emit) async {
    emit(ModelEditViewStateChanged<T>(state.model));
  }

  void _onModelEditViewEventMode(
      ModelEditViewEventMode<T> event, Emitter<ModelEditViewState<T>> emit) async {
    if (event.isEditMode) {
      emit(ModelEditViewStateEdit<T>(state.model));
    } else {
      emit(ModelEditViewStateView<T>(state.model));
    }
  }

  void _onModelEditViewEventSave(
      ModelEditViewEventSave<T> event, Emitter<ModelEditViewState<T>> emit) async {
    try {
      emit(ModelEditViewStateSaving<T>(state.model));
      if (state.model == null) {
        // var newModel = await dao.create(event.values);
        var newModel = await doAddModel(
            dao, attachmentDao, event.values, loggy, event.deleteAttachment);

        emit(ModelEditViewStateEdit<T>(newModel));
      } else {
        //await dao.update(state.model!.id, event.values);
        await doUpdateModel(dao, attachmentDao, state.model!.id, event.values,
            loggy, event.deleteAttachment);

        emit(ModelEditViewStateEdit<T>(state.model));
      }

      if (event.isEditMode != null) {
        add(ModelEditViewEventMode(event.isEditMode!));
      }
    } catch (e) {
      loggy.info(e);
      emit(ModelEditViewStateError<T>(
          "Error saving the item ${e.toString()}", e, state.model));
    }
  }
}
