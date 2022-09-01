part of flutter_model;

abstract class ModelCacheProvider<T extends IModel> {
  const ModelCacheProvider();

  Future<void> writeToStorage(List<T> models);
  Future<List<T>?> readFromStorage();
}
