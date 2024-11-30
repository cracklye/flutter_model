import 'dart:io';

import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:flutter_model/flutter_model.dart';

class RepositoryDailyActionMemorySlow extends IInMemoryAPI<DailyAction> {
  RepositoryDailyActionMemorySlow([items, fileCacheProvider])
      : super(initItems: items, fileCacheProvider: fileCacheProvider);

  @override
  DailyAction createFromMap(Map<String, dynamic> values) {
    return DailyAction.fromJson(values);
  }

  @override
  DailyAction createNewModel<S>({dynamic parentId}) {
    return DailyAction(name: "New forecast", description: "");
  }

  @override
  List<DailyAction> queryItems() {
    sleep(const Duration(seconds: 2));
    return queryItems();
  }
}
