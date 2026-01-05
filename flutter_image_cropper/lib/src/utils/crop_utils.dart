import 'dart:io';
import 'dart:ui' as ui;

Future<File> uiImageToFile(
  ui.Image image, {
  required Future<Directory> destinationDir,
}) async {
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final path = (await destinationDir).path;

  final file = File("$path/image_${DateTime.now().millisecondsSinceEpoch}.png");

  await file.writeAsBytes(byteData!.buffer.asUint8List());
  return file;
}
