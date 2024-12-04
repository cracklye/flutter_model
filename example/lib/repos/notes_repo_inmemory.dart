import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:example/notes/model_notes.dart';
import 'package:flutter_model/flutter_model.dart';

class RepositoryNotesMemory extends IInMemoryAPI<Notes> {
  RepositoryNotesMemory([items, fileCacheProvider])
      : super(initItems: items, fileCacheProvider: fileCacheProvider);

  @override
  Notes createFromMap(Map<String, dynamic> values) {
    return Notes.fromJson(values);
  }

  @override
  Notes createNewModel<S>({dynamic parentId}) {
    return Notes(name: "New forecast", description: "");
  }
}

class RepositoryDailyActionMemory extends IInMemoryAPI<DailyAction> {
  RepositoryDailyActionMemory([items, fileCacheProvider])
      : super(initItems: items, fileCacheProvider: fileCacheProvider);

  @override
  DailyAction createFromMap(Map<String, dynamic> values) {
    return DailyAction.fromJson(values);
  }

  @override
  DailyAction createNewModel<S>({dynamic parentId}) {
    return DailyAction(name: "New Daily Action", description: "");
  }
}
