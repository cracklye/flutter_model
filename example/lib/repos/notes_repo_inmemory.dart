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
