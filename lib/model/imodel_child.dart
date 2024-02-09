
import 'package:flutter_model/flutter_model.dart';

/// This is the base model for all data entities.
abstract class IModelChild extends IModel {
  /// This is a unique id for this model.  the type will vary depending
  /// on the API that is being used for storing it.
  dynamic get parentId;
  
}
