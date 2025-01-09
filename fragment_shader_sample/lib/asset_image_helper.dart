import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

final class AssetImageHelper {
  const AssetImageHelper._();

  static Future<ui.Image> decodeAssetImageAsUiImage(BuildContext context, String path) async {
    final myImage = await DefaultAssetBundle.of(context).load(path);
    final bytes = myImage.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes));
    final frame = await codec.getNextFrame();

    return frame.image;
  }

  static Future<ui.Image> takeCanvasPicture(int width, int height, Color color) async {
    final transparentPainter = Paint();
    transparentPainter.color = color;

    var uiRecorder = ui.PictureRecorder();
    Canvas(uiRecorder).drawRect(
        Rect.fromLTRB(
          0,
          0,
          width.toDouble(),
          height.toDouble(),
        ),
        transparentPainter);
    final picture = uiRecorder.endRecording();
    return picture.toImage(width, height);
  }
}
