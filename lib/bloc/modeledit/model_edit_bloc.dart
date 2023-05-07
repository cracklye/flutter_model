
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

abstract class ModelEditState<T extends IModel> {
  final T? model;
  const ModelEditState([this.model]);
}

class ModelEditStateNotLoaded<T extends IModel> extends ModelEditState<T> {
  const ModelEditStateNotLoaded() : super(null);
}

abstract class ModelEditStateEdit<T extends IModel> extends ModelEditState<T> {
  const ModelEditStateEdit([super.model]);
}

class ModelEditStateLoaded<T extends IModel> extends ModelEditStateEdit<T> {
  const ModelEditStateLoaded([super.model]);
}

class ModelEditStateSaved<T extends IModel> extends ModelEditStateEdit<T> {
  const ModelEditStateSaved([super.model]);
}

class ModelEditStateSaving<T extends IModel> extends ModelEditStateEdit<T> {
  const ModelEditStateSaving([super.model]);
}

class ModelEditStateError<T extends IModel> extends ModelEditState<T> {
  final dynamic e;
  final String message;
  const ModelEditStateError(this.message, [this.e, super.model]);
}

abstract class ModelEditEvent<T extends IModel> {
  const ModelEditEvent();
}

class ModelEditEventClear<T extends IModel> extends ModelEditEvent<T> {
  const ModelEditEventClear();
}

class ModelEditEventSave<T extends IModel> extends ModelEditEvent<T> {
  final Map<String, dynamic> values;
  final bool deleteAttachment;
  final dynamic id;
  final dynamic parentId;

  const ModelEditEventSave(this.values,
      {this.deleteAttachment = false, this.parentId, this.id});
}

class ModelEditEventCreateNew<T extends IModel> extends ModelEditEvent<T> {
  final dynamic parentId;
  const ModelEditEventCreateNew([this.parentId]);
}

class ModelEditEventLoad<T extends IModel> extends ModelEditEvent<T> {
  final dynamic id;
  const ModelEditEventLoad(this.id);
}

class ModelEditEventSelect<T extends IModel> extends ModelEditEvent<T> {
  final T? model;
  const ModelEditEventSelect(this.model);
}

class ModelEditBloc<T extends IModel>
    extends Bloc<ModelEditEvent<T>, ModelEditState<T>>
    with UiLoggy, HandleAttachment<T> {
  IModelAPI<T> dao;
  final AttachmentDAO? attachmentDao;
  ModelEditBloc(this.dao, this.attachmentDao,
      [super.initialState = const ModelEditStateNotLoaded()]) {
    on<ModelEditEventSave<T>>(_onModelEditEventSave);
    on<ModelEditEventCreateNew<T>>(_onModelEditEventCreateNew);
    on<ModelEditEventClear<T>>(_onModelEditEventClear);
    on<ModelEditEventLoad<T>>(_onModelEditEventLoad);
    on<ModelEditEventSelect<T>>(_onModelEditEventSelect);
  }

  void _onModelEditEventClear(
      ModelEditEventClear<T> event, Emitter<ModelEditState<T>> emit) async {
    emit(ModelEditStateNotLoaded<T>());
  }

  void _onModelEditEventCreateNew(
      ModelEditEventCreateNew<T> event, Emitter<ModelEditState<T>> emit) async {
    emit(ModelEditStateLoaded<T>(
      null,
    ));
  }

  void _onModelEditEventLoad(
      ModelEditEventLoad<T> event, Emitter<ModelEditState<T>> emit) async {
    T? model = await dao.getById(event.id);
    if (model == null) {
      emit(ModelEditStateError("Unable to find model with the ID=${event.id}"));
    } else {
      emit(ModelEditStateLoaded<T>(
        model,
      ));
    }
  }

  void _onModelEditEventSelect(
      ModelEditEventSelect<T> event, Emitter<ModelEditState<T>> emit) async {
    emit(ModelEditStateLoaded<T>(
      event.model,
    ));
  }

  void _onModelEditEventSave(
      ModelEditEventSave<T> event, Emitter<ModelEditState<T>> emit) async {
    try {
      emit(ModelEditStateSaving<T>(state.model));
      if (state.model == null) {
        // var newModel = await dao.create(event.values);
        var newModel = await doAddModel(
            dao, attachmentDao, event.values, loggy, event.deleteAttachment);

        emit(ModelEditStateSaved<T>(newModel));
      } else {
        //await dao.update(state.model!.id, event.values);
        await doUpdateModel(dao, attachmentDao, state.model!.id, event.values,
            loggy, event.deleteAttachment);

        emit(ModelEditStateSaved<T>(state.model));
      }
    } catch (e) {
      loggy.info(e);
      emit(ModelEditStateError<T>(
          "Error saving the item ${e.toString()}", e, state.model));
    }
  }
}
