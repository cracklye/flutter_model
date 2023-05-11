import 'dart:io';

import 'package:example/sample/model_sample.dart';
import 'package:flutter_model/flutter_model.dart';

class RepositorySampleMemorySlow extends IInMemoryAPI<Sample> {
  RepositorySampleMemorySlow([items, fileCacheProvider])
      : super(initItems: items, fileCacheProvider: fileCacheProvider);

  @override
  Sample createFromMap(Map<String, dynamic> values) {
    return Sample.fromJson(values);
  }

  @override
  Sample createNewModel<S>({dynamic parentId}) {
    return Sample(name: "New Sample", description: "");
  }

  @override
  List<Sample> queryItems() {
    sleep(Duration(seconds: 2));
    return super.queryItems();
  }
}

