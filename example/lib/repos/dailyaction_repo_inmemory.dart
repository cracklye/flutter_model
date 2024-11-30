import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:flutter_model/flutter_model.dart';

class RepositoryDailyActionMemory extends IInMemoryAPI<DailyAction> {
  RepositoryDailyActionMemory([items, fileCacheProvider])
      : super(initItems: items, fileCacheProvider: fileCacheProvider);

  @override
  DailyAction createFromMap(Map<String, dynamic> values) {
    return DailyAction.fromJson(values);
  }

  @override
  DailyAction createNewModel<S>({dynamic parentId}) {
    return DailyAction(name: "New forecast", description: "");
  }
}
