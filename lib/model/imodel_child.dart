part of flutter_model; 


/// This is the base model for all data entities.
abstract class IModelChild {
  /// This is a unique id for this model.  the type will vary depending
  /// on the API that is being used for storing it.
  dynamic get parentId;
  
}
