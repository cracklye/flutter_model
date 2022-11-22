part of flutter_model;

class AttachmentViewer extends StatelessWidget {
  const AttachmentViewer({
    super.key,
    required this.model,
    required this.fieldName,
    this.fit ,
    this.repeat = ImageRepeat.repeat,
  });
  final BoxFit? fit;
  final IModel model;
  final String fieldName;
  final ImageRepeat repeat;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
      future: AttachmentDAO.getImage(
        model,
        model.toJson()[fieldName],
        fieldName,
      ),
      builder: (BuildContext context, AsyncSnapshot<ImageProvider> image) {
        if (image.hasData) {
          return Image(
            repeat: repeat,
            image: image.data!,
            fit: fit,
          ); // image is ready
        } else {
          return Container(); // placeholder
        }
      },
    );
  }
}
