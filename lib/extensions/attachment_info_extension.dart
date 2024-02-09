import 'package:flutter_model/bloc/modelbloc/model_event.dart';
import 'package:flutter_model/extensions/attachment_info.dart';

extension AttachmentInfoToJson on AttachmentInfo {
  Map<String, dynamic> toJson(String fieldName) {
    Map<String, dynamic> rtn = {};
    if (path != null) {
      rtn.putIfAbsent(fieldAttachmentPath, () => path);
    }
    if (content != null) {
      rtn.putIfAbsent(fieldAttachmentContent, () => content);
    }
    if (fileExtension != null) {
      rtn.putIfAbsent(fieldAttachmentExtension, () => fileExtension);
    }
    if (contentType != null) {
      rtn.putIfAbsent(fieldAttachmentContentType, () => contentType);
    }
    rtn.putIfAbsent(fieldAttachmentFieldName, () => fieldName);

    return rtn;
  }
}
