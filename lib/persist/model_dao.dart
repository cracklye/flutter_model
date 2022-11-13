part of flutter_model;

abstract class IModelAPI<T extends IModel> {
  Future<dynamic> init([dynamic props]);
  Future<dynamic> disconnect();

  //Future<dynamic> save(T model) ;

  /// Updates an existing record in the data store with the model provided.
  ///
  /// Returns the ID of the model (this should match the model passed in unless the model hasn't been saved previously)
  Future<dynamic> updateModel(T model);
  Future<dynamic> update(dynamic id, Map<String, dynamic> values);

  /// Creates a new record for the
  Future<T> createModel(T model);

  ///Creates a new record based on the values passed in [values]
  Future<T> create(Map<String, dynamic> values);

  /// Delete the record for the model passed in.
  Future<dynamic> deleteModel(T model);

  /// Returns a alist of models based on the search parameters provided
  Future<List<T>> listModels({String? parentId, String? searchText,  List<SortOrderBy>? orderBy, List<Filter>? filters});

  /// Returns a stream of models based on the search parameters provided
  Future<Stream<List<T>>> list({String? parentId, String? searchText, List<SortOrderBy>? orderBy, List<Filter>? filters});

  Future<Stream<T?>> listById(
    dynamic id,
  );

  /// Returns the object that matches the [id] passed through (and [parentId] if the model is a child)
  Future<T?> getById(dynamic id);

  /// Create a new type, if this has multiple sub types then pass in the type in S, otherwise this can 
  /// be ignored.
  T createNewModel<S>({String? parentId});


  Future<dynamic> deleteByParentId(dynamic parentId);

  Future<dynamic> deleteById(dynamic id);
 



}
