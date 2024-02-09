import 'dart:typed_data';

class AttachmentInfo {
  AttachmentInfo(
      {this.path,
      this.content,
      this.fileExtension,
      this.contentType,
      this.isUpdated = false,
      this.isClear = false,
      this.fileSize = 0});

  final String? path;
  final Uint8List? content;
  final String? fileExtension;
  final String? contentType;
  final bool isUpdated;
  final bool isClear;
  final int fileSize;

  factory AttachmentInfo.empty() {
    return AttachmentInfo(isUpdated: false, isClear: false);
  }
  factory AttachmentInfo.clear() {
    return AttachmentInfo(isUpdated: false, isClear: true);
  }

  @override
  String toString() {
    return 'path: $path, contentType: $contentType, ext: $fileExtension';
  }
}
