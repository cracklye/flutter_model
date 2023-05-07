
import 'package:flutter_model/flutter_model.dart';

abstract class ModelCacheProvider<T extends IModel> {
  const ModelCacheProvider();

  Future<void> writeToStorage(List<T> models);
  Future<List<T>?> readFromStorage();
}
