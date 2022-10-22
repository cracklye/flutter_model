part of flutter_model;

abstract class AttachmentDAO {
  static late AttachmentDAO active;
  static Future<ImageProvider> getImage(
      IModel coverImage, Map<String, dynamic>? details, String field) {
    //Return image...
    return active.getImageProvider(coverImage, details, field);
  }
Future<Map<String, dynamic>?> removeContentPost(String fieldName,
dynamic id);
  


  Future<Map<String, dynamic>?> saveContentPost(String fieldName,
      Uint8List data, String? ext, dynamic id, String? mimeType);
  Future init([String? rootPath]);

  Future<void> savePathPost(
      String fieldName, String srcPath, dynamic id, String? mimeType);

  Future<Map<String, dynamic>?> saveContent(
      String fieldName, Uint8List data, String? ext, String? mimeType);
  Future<Map<String, dynamic>?> savePath(
      String fieldName, String srcPath, String? mimeType);

  Future<ImageProvider> getImageProvider(
      IModel coverImage, Map<String, dynamic>? details, String field);
}

class AttachmentDaoFilesystem extends AttachmentDAO {
  @override
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
@override

Future<Map<String, dynamic>?> removeContentPost(String fieldName,
dynamic id) async{
  //Delete it and return null; 
return null;
}
@override
  Future<ImageProvider> getImageProvider(
      IModel coverImage, Map<String, dynamic>? details, String field) async {
    var f = FileImage(File(""));
    return f;
  }
@override
  Future<Map<String, dynamic>?> saveContentPost(String fieldName,
      Uint8List data, String? ext, dynamic id, String? mimeType) async {}

  static String _rootPath = "";

  final String subdir = "attachments";

  // final String path = "D:\\Temp\\NotTakingApp\\attachments\\";

  static String getPath(String input) {
    if (input.startsWith("http")) {
      return input;
    }
    return '$_rootPath\\$input';
  }
@override
  Future<Map<String, dynamic>?> savePath(
      String fieldName, String srcPath, String? mimeType) async {
    String uid = const Uuid().v4();
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
@override
  Future<Map<String, dynamic>?> saveContent(
      String fieldName, Uint8List data, String? ext, String? mimeType) async {
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

  @override
  Future<void> savePathPost(
      String fieldName, String srcPath, id, String? mimeType) async {}
}
