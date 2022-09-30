part of flutter_model;

class AttachmentDAO {

  final String path = "D:\\Temp\\NotTakingApp\\attachments\\";

  static String getPath(String input){
    return input; 
  }


  Future<Map<String, dynamic>?> savePath(
      String fieldName, String srcPath) async {
    String uid = Uuid().v4();
    var src = File(srcPath);
    var ext = extension(srcPath);
    var newf = await src.copy(path + "\\" + uid + ext);

    return Future.value({
      "${fieldName}Uri": newf.absolute.path,
      "${fieldName}ThumbnailUri": "/thumbnail/jpg"
    });
  }

  Future<Map<String, dynamic>?> saveContent(
      String fieldName, Uint8List data, String? ext) async {
    String uid = Uuid().v4();

    var newf = File(path + "\\" + uid + (ext ?? ""));
    var sink = await newf.writeAsBytes(data);

    return Future.value({
      "${fieldName}Uri": newf.absolute.path,
      "${fieldName}ThumbnailUri": "/thumbnail/jpg"
    });
  }
}
