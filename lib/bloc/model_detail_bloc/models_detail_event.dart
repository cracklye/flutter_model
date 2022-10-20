part of flutter_model;

abstract class ModelsDetailEvent<T extends IModel> {
  const ModelsDetailEvent();
}


/// Raised when the selection criteria is changed or when the models need to
/// be loaded for the first time.
class ModelsDetailLoad<T extends IModel> extends ModelsDetailEvent<T> {
  /// The parent ID that has been set to filter by
  final dynamic id;

  const ModelsDetailLoad(
      {this.id});
}

/// Raised when a document needs to be deleted
class ModelsDetailDelete<T extends IModel> extends ModelsDetailEvent<T> {
  /// The model to delete
  final T model;

  const ModelsDetailDelete(this.model);
}

class ModelsDetailUpdateDetail<T extends IModel> extends ModelsDetailEvent<T>{
  final T model;
 const ModelsDetailUpdateDetail( this.model);
}