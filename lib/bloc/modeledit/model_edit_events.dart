import 'package:flutter_model/flutter_model.dart';

abstract class ModelEditViewEvent<T extends IModel> {
  const ModelEditViewEvent();
}

class ModelEditViewEventDelete<T extends IModel> extends ModelEditViewEvent<T> {
  final String id;
  const ModelEditViewEventDelete(this.id);
}

class ModelEditViewEventClear<T extends IModel> extends ModelEditViewEvent<T> {
  const ModelEditViewEventClear();
}

class ModelEditViewEventSave<T extends IModel> extends ModelEditViewEvent<T> {
  final Map<String, dynamic> values;
  final bool? isEditMode;
  final bool deleteAttachment;
  final dynamic id;
  final dynamic parentId;

  Map<String, dynamic> get valuesWithParent {
    if (parentId == null) return values;
    if (values.containsKey("parentId")) return values;
    return {...values, "parentId": parentId};
  }

  const ModelEditViewEventSave(this.values,
      {this.isEditMode, this.deleteAttachment = false, this.id, this.parentId});
}

class ModelEditViewEventChanged<T extends IModel>
    extends ModelEditViewEvent<T> {
  const ModelEditViewEventChanged();
}

class ModelEditViewEventCreateNew<T extends IModel>
    extends ModelEditViewEvent<T> {
  final String? parentId;
  const ModelEditViewEventCreateNew([this.parentId]);
}

class ModelEditViewEventMode<T extends IModel> extends ModelEditViewEvent<T> {
  final bool isEditMode;
  const ModelEditViewEventMode(this.isEditMode);
}

class ModelEditViewEventSelect<T extends IModel> extends ModelEditViewEvent<T> {
  final bool isEditMode;
  final dynamic id;

  const ModelEditViewEventSelect(this.id, this.isEditMode);
}

class ModelEditViewEventSelectModel<T extends IModel>
    extends ModelEditViewEvent<T> {
  final bool isEditMode;
  final T? model;

  const ModelEditViewEventSelectModel(this.model, this.isEditMode);
}
