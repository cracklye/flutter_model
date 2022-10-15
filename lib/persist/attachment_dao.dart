part of flutter_model;

class AttachmentDAO {
  Future init([String? rootPath]) async {
    if (rootPath != null) {
      _rootPath = rootPath;
    } else {
      var file = await getApplicationSupportDirectory();
      _rootPath = file.path;
    }
    Directory f = Directory('$_rootPath\\$subdir');
    if (!f.existsSync()) {
      f.createSync();
    }
  }

  static String _rootPath = "";

  final String subdir = "attachments";

  // final String path = "D:\\Temp\\NotTakingApp\\attachments\\";

  static String getPath(String input) {
    if(input.startsWith("http")){
      return input;
    }
    return '$_rootPath\\$input';
  }

  Future<Map<String, dynamic>?> savePath(
      String fieldName, String srcPath) async {
    String uid =const Uuid().v4();
    var ext = extension(srcPath);
    String relativeURI = '$subdir\\$uid$ext';
    String fullUri = '$_rootPath\\$relativeURI';

    var src = File(srcPath);
    await src.copy(fullUri);

    return Future.value({
      "${fieldName}Uri": relativeURI,
      "${fieldName}ThumbnailUri": "/thumbnail/jpg"
    });
  }

  Future<Map<String, dynamic>?> saveContent(
      String fieldName, Uint8List data, String? ext) async {
    String uid = const Uuid().v4();

    String relativeURI = '$subdir\\$uid$ext';
    String fullUri = '$_rootPath\\$relativeURI';

    var newf = File(fullUri);
    //var sink =
    await newf.writeAsBytes(data);

    return Future.value({
      "${fieldName}Uri": relativeURI,
      "${fieldName}ThumbnailUri": "/thumbnail/jpg"
    });
  }
}
