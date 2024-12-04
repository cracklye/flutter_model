import 'package:example/notes/model_notes.dart';
import 'package:flutter_model_couchbase/flutter_model_couchbase.dart';

class NotesDaoCouchbase extends CouchbaseDAO<Notes> {
  NotesDaoCouchbase(super.database) : super();

  @override
  Notes createFromMap(Map<String, dynamic> values) {
    //TODO probably can remove this...
    values.putIfAbsent("textDisplayMode", () => "markdown");

    return Notes.fromJson(values);
  }

  @override
  Notes createNewModel<S>({String? parentId}) {
    return Notes(name: "New Note", description: "");
  }
}
