import 'package:parse_server_sdk/parse_server_sdk.dart';

class ImageParse {
  final String objectId;
  final String fileURL;
  ImageParse({
    required this.objectId,
    required this.fileURL,
  });

  static ImageParse getImageFromImageParseObject(ParseObject imageParseObject) {
    final objectId = imageParseObject.objectId!;

    final imageFile = imageParseObject.get<ParseFileBase>('file');
    final fileURL = imageFile!.url!;

    return ImageParse(objectId: objectId, fileURL: fileURL);
  }
}
