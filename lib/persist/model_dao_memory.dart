
import 'dart:async';

import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';
import 'package:uuid/uuid.dart';

/// This provides an in memory API that can be used for testing purposes
/// The data is held within a list in the class so will be lost as soon
/// as the object is removed from memory.
abstract class IInMemoryAPI<T extends IModel> extends IModelAPI<T>
    with UiLoggy {
  final ModelCacheProvider<T>? fileCacheProvider;

  /// The list of items stored in the API
  List<T> items = [];

  StreamController<List<T>>? controller;
  String? activeParentId;

  /// stores the next ID that can be used when creating a new model in this API.
  // int _id = 0;

  IInMemoryAPI({List<T>? initItems, this.fileCacheProvider}) {
    if (initItems != null) items = initItems;
  }

  @override
  Future<dynamic> deleteByParentId(dynamic parentId) async {
    loggy.debug("CouchbaseDAO.deleteByParentId $parentId");
    loggy.error("Not implemented correctly");
  }

  @override
  Future<dynamic> init([dynamic props]) async {
    loggy.debug("IInMemoryAPI.connectStart <$props>");
    if (fileCacheProvider != null) {
      var tmp = await fileCacheProvider!.readFromStorage();

      if (tmp != null) items = tmp;
      if (controller != null) {
        controller!.sink.add(items);
      }
    }

    return Future.value(true);
  }

  Future<void> _saveToFiles() async {
    if (fileCacheProvider != null) {
      await fileCacheProvider!.writeToStorage(items);
    }
  }

  @override
  Future<dynamic> disconnect() {
    loggy.debug("IInMemoryAPI.disconnect");
    return Future.value(true);
  }

  T createFromMap(Map<String, dynamic> values);

  @override
  Future<T> create(Map<String, dynamic> values) async {
    //Add the defaults...
    loggy.debug("IInMemoryAPI.create $values");
    //values.putIfAbsent("id", () => getNextId());

    T model = createFromMap(values);

    return await createModel(model);
  }

  String getNextId() {
    //_id += 1;

    var uuid = const Uuid();

    return uuid.v4();
  }

  @override
  Future<T> createModel(T model) {
    T nw = model.copyWithId(
        id: getNextId(),
        createdDate: DateTime.now(),
        modifiedDate: DateTime.now()) as T;
    items.add(nw);
    if (controller != null) controller!.sink.add(queryItems());

    _saveToFiles();

    return Future.value(nw);
  }

  List<T> queryItems() {
    var itemsToUse = items;
    if (activeParentId != null) {
      try {
        itemsToUse = items
            .where((element) =>
                (element as IModelChild).parentId == activeParentId)
            .toList();
      } catch (e) {
         loggy.warning("Unable to process $e");
      }
      //Unable to do it...

    }
    return itemsToUse;
  }

  @override
  Future<Stream<List<T>>> list(
      {String? parentId,
      String? searchText,
      List<SortOrderBy>? orderBy,
      List<Filter>? filters}) async {
    if (controller != null) {
      controller!.close();
    }
    activeParentId = parentId;
    List<T> itemsToUse = queryItems();

    controller = StreamController<List<T>>();
    controller!.sink.add([...itemsToUse]);

    if (searchText != null && searchText != "") {
      //Filter based on the text as we're not handling it elsewhere....
      return controller!.stream.map((event) =>
          event.where((element) => element.filter(searchText)).toList());
    }
    return controller!.stream;
  }

  @override
  Future<dynamic> update(dynamic id, Map<String, dynamic> values) async {
    //Get the current model...
    T? model = await getById(id);
    if (model == null) {
      throw Exception("Unable to find the model with id of $id");
    }
    model = model.copyWithId(modifiedDate: DateTime.now()) as T;
    var map = model.toJson();
    map.addAll(values);
    model = createFromMap(map);

    var rtn = await updateModel(model);

    return rtn;
  }

  @override
  Future<dynamic> updateModel(T model) {
    //T nw = model;

    try {
      //Get the index....
      var itmToRemove = items.firstWhere((element) => element.id == model.id);
      int idx = items.indexOf(itmToRemove);
      items.replaceRange(idx, idx + 1, [model]);
      items.removeAt(idx);
      model = model.copyWithId(modifiedDate: DateTime.now()) as T;
      items.insert(idx, model);

      // items.removeWhere((itm) {
      //   return itm.id == model.id;
      // });
      // items.add(nw);
      // items = [...items];

      if (controller != null) {
        List<T> itemsToUse = queryItems();
        controller!.sink.add([...itemsToUse]);
      }

      if (model.id == _listByIdKey && _listByIdStream != null) {
        _listByIdStream!.sink.add(model);
      }
      //       StreamController<T?>? _listByIdStream;
      // String _listByIdKey;
      _saveToFiles();

      return Future.value(model);
    } catch (e) {
      return createModel(model);
    }
  }

  @override
  Future<dynamic> deleteModel(T model) {
    deleteById(model.id);

    return Future.value(true);
  }

  @override
  Future<dynamic> deleteById(dynamic id) {
    try {
      items.removeWhere((itm) {
        return itm.id == id;
      });

      if (controller != null) {
        List<T> itemsToUse = queryItems();
        controller!.sink.add([...itemsToUse]);
      }

      if (id == _listByIdKey && _listByIdStream != null) {
        _listByIdStream!.sink.add(null);
      }

      _saveToFiles();
    } catch (e) {
      //print("Unable to delete $e");
    }

    return Future.value(true);
  }

  @override
  Future<List<T>> listModels(
      {String? parentId,
      String? searchText,
      List<SortOrderBy>? orderBy,
      List<Filter>? filters}) {
    return Future.value([...items]);
  }

  //Stream
  StreamController<T?>? _listByIdStream;
  String? _listByIdKey;

  @override
  Future<Stream<T?>> listById(
    dynamic id,
  ) async {
    if (_listByIdStream != null) {
      _listByIdStream!.sink.close();
    }

    _listByIdKey = id;
    _listByIdStream = StreamController<T?>();
    var future = getById(id);

    future.then((value) => _listByIdStream!.sink.add(value));
    return _listByIdStream!.stream;
  }

  @override
  Future<T?> getById(
    dynamic id,
  ) {
    try {
      T rtn = items.singleWhere((itm) {
        return itm.id == id;
      });

      return Future.value(rtn);
    } catch (e) {
      // throw new Exception
       loggy.warning("Unable to find the entry with the id=$id   $e");
      return Future.value(null);
    }
  }
}
