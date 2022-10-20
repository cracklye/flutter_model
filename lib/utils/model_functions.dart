part of flutter_model;
/// Returns the name of the model (in lowercase) from the type passed in as the type of the function.
String getModelKeyFromType<T extends IModel>() {
  Type t2 = T;
  String rtn = t2.toString().toLowerCase();
  return rtn;
}
