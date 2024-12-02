import 'package:flutter_model/flutter_model.dart';

abstract class ModelEditViewState<T extends IModel> {
  final T? model;
  final String? errorMessage;
  final dynamic exception;

  const ModelEditViewState({this.model, this.exception, this.errorMessage});

  /// Has the content of the item changed while
  /// in edit mode.  If edit mode = false this will always be false.
  bool get isChanged => false;

  /// whether the current document is in edit mode
  bool get isEditMode => false;

  ///  Whether the bloc is currently loading the document
  bool get isLoading => false;

  /// If nothing has happened, no document loaded it is classed as empty
  bool get isEmpty => (model == null);

  /// Has the document been successfully saved/updated
  bool get isSaved => false;

  /// Is the currently loaded document a new document (i.e. unsaved)
  bool get isNewDoc => false;

  /// Is the currently loaded document a new document (i.e. unsaved)
  bool get isSaving => false;
}

/// This is the default state and means that nothing has yet been loaded.
class ModelEditViewStateNotLoaded<T extends IModel>
    extends ModelEditViewState<T> {
  const ModelEditViewStateNotLoaded({super.errorMessage, super.exception});
}

/// This determines that the requested document is currently loading
class ModelEditViewStateLoading<T extends IModel>
    extends ModelEditViewState<T> {
  const ModelEditViewStateLoading({super.errorMessage, super.exception});

  @override
  bool get isLoading => true;
}

class ModelEditViewStateLoaded<T extends IModel> extends ModelEditViewState<T> {
  @override
  final bool isEditMode;
  @override
  final bool isChanged;
  @override
  final bool isSaving;
  @override
  final bool isNewDoc;
  @override
  final bool isSaved;

  const ModelEditViewStateLoaded(
      {super.model,
      this.isSaving = false,
      this.isChanged = false,
      this.isEditMode = false,
      this.isNewDoc = false,
      this.isSaved = false,
      super.errorMessage,
      super.exception});

  ModelEditViewStateLoaded<T> copyWith(
      {bool? isEditMode,
      bool? isChanged,
      bool? isSaving,
      bool? isNewDoc,
      bool? isSaved,
      String? errorMessage,
      dynamic exception,
      T? model}) {
    return ModelEditViewStateLoaded<T>(
      isEditMode: isEditMode ?? this.isEditMode,
      isChanged: isChanged ?? this.isChanged,
      isSaving: isSaving ?? this.isSaving,
      isNewDoc: isNewDoc ?? this.isNewDoc,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage ?? this.errorMessage,
      exception: exception ?? this.exception,
      model: model ?? this.model,
    );
  }
}
