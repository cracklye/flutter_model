
/// This is the base model for all data entities.
abstract class IModel {
  /// This is a unique id for this model.  the type will vary depending
  /// on the API that is being used for storing it.
  dynamic get id;

  /// Returns a map representing the values stored within this model.
  Map<String, dynamic> toJson();

  /// return a label that can be used for display purposes that will identify this instance of IModel.
  ///
  /// Normally a name or firstname + surname.
  /// This will be displayed by default for all drop downs or lists if no override has been provided.
  String get displayLabel;

  IModel copyWithId(
      {dynamic id, DateTime? createdDate, DateTime? modifiedDate});
  //IModel copyWithDates({DateTime? createdDate, DateTime? modifiedDate});

  /// The date the model was created (saved)
  DateTime? get createdDate;

  /// The date the model was last modified
  DateTime? get modifiedDate;

  /// A quick method for filtering based on a search string.
  bool filter(String searchText) {
    var map = toJson();
    for (var val in map.values) {
      if (val != null) {
        if (val.toString().toLowerCase().contains(searchText.toLowerCase())) {
          return true;
        }
      }
    }
    return false;
  }
}
