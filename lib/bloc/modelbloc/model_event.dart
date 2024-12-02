import 'package:flutter_model/flutter_model.dart';

abstract class ModelsEvent<T extends IModel> {
  const ModelsEvent();
}

// class ModelSelect<T extends IModel> extends ModelsEvent<T> {
//   final T? model;
//   final ModelStateMode mode;
//   ModelSelect([this.model, this.mode = ModelStateMode.view]);
// }

// class LoadModels<T extends IModel> extends ModelsEvent<T> {
//   final dynamic parentId;
//   final dynamic id;
//   final bool clear;
//   const LoadModels({this.parentId, this.id, this.clear = false});
// }

class UpdateParameters<T extends IModel> extends ModelsEvent<T> {
  UpdateParameters(this.parameters);

  final Map<String, dynamic> parameters;
}

// class RefreshLoadModel<T extends IModel> extends ModelsEvent<T> {
//   const RefreshLoadModel();
// }



/// This class is designed for use when you wish to
/// select a model in this state.
class ModelSelect<T extends IModel> extends ModelsEvent<T> {
  /// The model to select
  final T? model;

  /// Whether you wish to append the selection to any currently selected items or not.
  final bool appendToSelection;

  ModelSelect([this.model, this.appendToSelection = false]);
}




/// Raised when the selection criteria is changed or when the models need to
/// be loaded for the first time.
class ModelsLoad<T extends IModel> extends ModelsEvent<T> {
  /// The parent ID that has been set to filter by
  final dynamic parentId;

  /// Whether to clear the selection
  final bool clear;

  /// A list of filters to apply to the selection
  final List<Filter>? filters;

  /// A list of order by items to use to order the selections
  final List<SortOrderBy>? orderBy;

  final String? searchtext; 

  const ModelsLoad(
      {this.parentId, this.filters, this.orderBy, this.clear = false, this.searchtext});
}

/// Raised when a document needs to be deleted
class ModelsDelete<T extends IModel> extends ModelsEvent<T> {
  /// The model to delete
  final T model;

  const ModelsDelete(this.model);
}

/// Raised when the edit mode is to be changed.  Not sure this is what we really care about?
///
class ModelsUpdateList<T extends IModel> extends ModelsEvent<T> {
  final List<T> models;
  const ModelsUpdateList(this.models);
}


class ModelsChangeSearchText<T extends IModel> extends ModelsEvent<T> {
  final String? searchText;
  const ModelsChangeSearchText(this.searchText);
}
class ModelsChangeOrderBy<T extends IModel> extends ModelsEvent<T> {
  final List<SortOrderBy>?  sortOrders;
  const ModelsChangeOrderBy(this.sortOrders);
}

class ModelsChangeFilter<T extends IModel> extends ModelsEvent<T> {
  final List<Filter<T>>? filters;
  const ModelsChangeFilter(this.filters);
}




class AddModel<T extends IModel> extends ModelsEvent<T> {
  final Map<String, dynamic> values;
  final bool editMode;
  final bool deleteAttachment;

  // final Uint8List? attachmentContent;
  // final String? attachmentFieldName;
  // final String? attachmentPath;
  // final String? attachmentExtension;

  const AddModel(this.values,
      {this.editMode = false, this.deleteAttachment = false
      // this.attachmentContent,
      // this.attachmentFieldName,
      // this.attachmentPath,
      // this.attachmentExtension
      });
}

const String fieldAttachmentContent = "attachmentContent";
const String fieldAttachmentExtension = "attachmentExtension";
const String fieldAttachmentContentType = "attachmentContentType";
const String fieldAttachmentPath = "attachmentPath";
const String fieldAttachmentFieldName = "attachmentFieldName";

class UpdateModel<T extends IModel> extends ModelsEvent<T> {
  final Map<String, dynamic> values;
  final dynamic id;
  final bool deleteAttachment;
  // final Uint8List? attachmentContent;
  // final String? attachmentFieldName;
  // final String? attachmentPath;
  // final String? attachmentExtension;

  const UpdateModel(this.id, this.values, {this.deleteAttachment = false}
      //{
      //   this.attachmentContent,
      // this.attachmentFieldName,
      // this.attachmentPath,
      // this.attachmentExtension
      //}
      );
}

/// Saves the selected model that is in the state.  (if the id is null then it creates a new model, if
/// not then the matching model is updated)
// class UpdateSelected<T extends IModel> extends ModelsEvent<T> {
//   const UpdateSelected();
// }

// class UpdateModelValue<T extends IModel> extends ModelsEvent<T> {
//   final T model;
//   const UpdateModelValue(this.model);
// }

// class DeleteModel<T extends IModel> extends ModelsEvent<T> {
//   final T model;

//   const DeleteModel(this.model);
// }

/// Creates a new empty model and sets it to the state.selected property
class CreateNewModel<T extends IModel> extends ModelsEvent<T> {
  const CreateNewModel();
}

// class ModelsUpdated<T extends IModel> extends ModelsEvent<T> {
//   final List<T> models;
//   final String? id;

//   const ModelsUpdated(this.models, [this.id]);
// }

// class SetEditMode<T extends IModel> extends ModelsEvent<T> {
//   final bool editMode;
//   const SetEditMode(this.editMode);
// }

class ModelsDeleteAttachment<T extends IModel> extends ModelsEvent<T> {
  final String id;
  final String fieldName;
  const ModelsDeleteAttachment(this.id, this.fieldName);
}
