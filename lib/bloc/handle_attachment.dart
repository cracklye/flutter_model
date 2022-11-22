part of flutter_model;

class HandleAttachment<T extends IModel> {
  Future<T> doAddModel(IModelAPI<T> dao, AttachmentDAO? attachmentDao,
      Map<String, dynamic> values, Loggy loggy) async {
    loggy.debug("HandleAttachment._onAddModel Started the onAddModel");
    var attachmentKey = await _handleAttachment(attachmentDao, values, loggy);

    if (attachmentKey != null) {
      for (var key in attachmentKey.keys) {
        values.update(
          key,
          (value) => attachmentKey[key],
          ifAbsent: () => attachmentKey[key],
        );
      }
      //values.update(event.attachmentFieldName!, (value) => attachmentKey);
    }
    var newModel = await dao.create(values);

    _handleAttachmentPost(attachmentDao, values, newModel.id, loggy);

    loggy.debug(
        "HandleAttachment._onAddModel Returning models new model= $newModel");
    return newModel;
  }

  Future<void> doUpdateModel(IModelAPI<T> dao, AttachmentDAO? attachmentDao,
      dynamic id, Map<String, dynamic> values, Loggy loggy) async {
    var attachmentKey = await _handleAttachment(attachmentDao, values, loggy);

    if (attachmentKey != null) {
      for (var key in attachmentKey.keys) {
        values.update(key, (value) => attachmentKey[key],
            ifAbsent: () => attachmentKey[key]);
      }
    }

    dao.update(id, values);

    _handleAttachmentPost(attachmentDao, values, id, loggy);
  }

  Future<Map<String, dynamic>?> _handleAttachment(AttachmentDAO? attachmentDao,
      Map<String, dynamic> values, Loggy loggy) async {
    if (values.containsKey(fieldAttachmentFieldName)) {
      Uint8List? attachmentContent = values[fieldAttachmentContent];
      String? attachmentFieldName = values[fieldAttachmentFieldName];
      String? attachmentPath = values[fieldAttachmentPath];
      String? attachmentExtension = values[fieldAttachmentExtension];

      loggy.debug(
          "HandleAttachment._handleAttachment attachmentFieldName= $attachmentFieldName");
      loggy.debug(
          "HandleAttachment._handleAttachment RattachmentPath= $attachmentPath");
      loggy.debug(
          "HandleAttachment._handleAttachment contentSet?= ${attachmentContent != null}");

      if (attachmentFieldName != null &&
          (attachmentContent != null || attachmentPath != null)) {
        //TODO need to delete if already in existance....
        loggy.debug("_handleAttachment Have content to save");

        if (attachmentDao == null) {
          throw ("Trying to save attachments with no attachmentDAO configured");
        }

        if (attachmentPath != null) {
          String? mimeType = lookupMimeType(attachmentPath);

          loggy.debug("HandleAttachment._handleAttachment Saving from path");
          return await attachmentDao!
              .savePath(attachmentFieldName, attachmentPath, mimeType);
        } else {
          String? mimeType =
              lookupMimeType('', headerBytes: attachmentContent!);

          loggy.debug("_handleAttachment Saving from content");
          return attachmentDao!.saveContent(attachmentFieldName,
              attachmentContent, attachmentExtension, mimeType);
        }
      }
    }
    return null;
  }

  String? doLookupMime(String? providedContentType, String? attachmentPath,
      {attachmentContent}) {
    // attachmentContentType
    //  lookupMimeType(attachmentContentType,'', headerBytes: attachmentContent!);
    if (providedContentType != null &&
        providedContentType != "" &&
        providedContentType != "unknown") {
      return providedContentType;
    }
    if (attachmentPath != null) {
      return lookupMimeType(attachmentPath);
    } else {
      return lookupMimeType('', headerBytes: attachmentContent);
    }
  }

  Future<void> _handleAttachmentPost(
      AttachmentDAO? attachmentDao,
      // Uint8List? attachmentContent,
      // String? attachmentFieldName,
      // String? attachmentPath,
      // String? attachmentExtension,
      Map<String, dynamic> values,
      dynamic id,
      Loggy loggy) async {
    if (values.containsKey(fieldAttachmentFieldName)) {
      Uint8List? attachmentContent = values[fieldAttachmentContent];
      String? attachmentFieldName = values[fieldAttachmentFieldName];
      String? attachmentPath = values[fieldAttachmentPath];
      String? attachmentExtension = values[fieldAttachmentExtension];
      String? attachmentContentType = values[fieldAttachmentContentType];

      loggy.debug(
          "HandleAttachment._handleAttachmentPost attachmentFieldName= $attachmentFieldName");
      loggy.debug(
          "HandleAttachment._handleAttachmentPost RattachmentPath= $attachmentPath");
      loggy.debug(
          "HandleAttachment._handleAttachmentPost contentSet?= ${attachmentContent != null}");

      if (attachmentFieldName != null &&
          (attachmentContent != null || attachmentPath != null)) {
        //TODO need to delete if already in existance....
        loggy.debug("HandleAttachment._handleAttachment Have content to save");

        if (attachmentDao == null) {
          throw ("Trying to save attachments with no attachmentDAO configured");
        }

        if (attachmentPath != null) {
          String? mimeType =
              doLookupMime(attachmentContentType, attachmentPath);

          loggy.debug("HandleAttachment._handleAttachment Saving from path");
          return await attachmentDao!
              .savePathPost(attachmentFieldName, attachmentPath, id, mimeType);
        } else {
          if (attachmentContent != null) {
            String? mimeType = doLookupMime(attachmentContentType, null,
                attachmentContent: attachmentContent);
            loggy.debug(
                "HandleAttachment._handleAttachment Saving from content");
            attachmentDao!.saveContentPost(attachmentFieldName,
                attachmentContent, attachmentExtension, id, mimeType);
          }
        }
      }
    }
  }
}
