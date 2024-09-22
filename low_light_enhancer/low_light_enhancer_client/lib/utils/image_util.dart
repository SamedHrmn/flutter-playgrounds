import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

final class ImageUtil {
  ImageUtil._();

  static Future<String?> pickImageFromGalleryAsBase64() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    final bytes = await image.readAsBytes();
    return _convertImageToBase64(bytes);
  }

  static String _convertImageToBase64(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }

  static Uint8List decodeBase64(String base64Str) => base64Decode(base64Str);
}
