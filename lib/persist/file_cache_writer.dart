part of flutter_model;

class FileSystemWriter<T extends IModel> extends ModelCacheProvider<T> {
  const FileSystemWriter(this.fromJson);

  final T Function(Map<String, dynamic>) fromJson;

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
print("App Directory: $directory");
    return directory.path;
  }

  String getModelKeyFromType<M extends IModel>() {
    Type t2 = M;
    String rtn = t2.toString().toLowerCase();
    return rtn;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    var filename = getModelKeyFromType<T>();

    return File('$path/$filename.json');
  }

  @override
  Future<List<T>?> readFromStorage() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      var rtn = jsonDecode(contents);

      List<T> toRtn = [];

      for (var itm in rtn) {
        toRtn.add(fromJson(itm));
      }

      return Future.value(toRtn);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> writeToStorage(List<IModel> models) async {
    var json = jsonEncode(models.map((e) => e.toJson()).toList());
    // Write the file
    final file = await _localFile;

    await file.writeAsString(json);
  }
}
