import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_image_cropper/flutter_image_cropper.dart';
import 'package:flutter_image_cropper/src/crop_overlay.dart';
import 'package:flutter_image_cropper/src/utils/crop_utils.dart';

class CropWidget extends StatefulWidget {
  final ImageProvider image;
  final CropController controller;
  final void Function(ui.Image image)? onCropped;
  final void Function()? onGestureStart;
  final Future<Directory> destinationDir;

  const CropWidget({
    super.key,
    required this.image,
    required this.controller,
    required this.destinationDir,
    this.onCropped,
    this.onGestureStart,
  });

  @override
  State<CropWidget> createState() => _CropWidgetState();
}

class _CropWidgetState extends State<CropWidget> {
  ui.Image? _image;
  CropHandle _activeHandle = CropHandle.none;
  Offset _startLocal = Offset.zero;
  Rect _startRect = Rect.zero;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    _resolveImage();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _resolveImage() {
    final stream = widget.image.resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener((info, _) {
        setState(() => _image = info.image);
      }),
    );
  }

  void _crop() async {
    if (_image == null) return;

    final img = _image!;
    final cropRectNorm = widget.controller.cropRect;

    final box = context.findRenderObject() as RenderBox;
    final widgetSize = box.size;

    final imageW = img.width.toDouble();
    final imageH = img.height.toDouble();

    final scale = math.max(
      widgetSize.width / imageW,
      widgetSize.height / imageH,
    );

    final displayW = imageW * scale;
    final displayH = imageH * scale;

    final dx = (displayW - widgetSize.width) / 2;
    final dy = (displayH - widgetSize.height) / 2;

    // 🔑 Gerçek image pixel crop
    final srcRect = Rect.fromLTWH(
      (cropRectNorm.left * widgetSize.width + dx) / scale,
      (cropRectNorm.top * widgetSize.height + dy) / scale,
      cropRectNorm.width * widgetSize.width / scale,
      cropRectNorm.height * widgetSize.height / scale,
    );

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImageRect(
      img,
      srcRect,
      Rect.fromLTWH(0, 0, srcRect.width, srcRect.height),
      Paint(),
    );

    final picture = recorder.endRecording();
    final result = await picture.toImage(
      srcRect.width.toInt(),
      srcRect.height.toInt(),
    );

    widget.onCropped?.call(result);

    final imageFile = await uiImageToFile(
      result,
      destinationDir: widget.destinationDir,
    );

    if (!mounted) return;

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CropResultView(image: imageFile)));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final cropRectPx = Rect.fromLTWH(
          widget.controller.cropRect.left * width,
          widget.controller.cropRect.top * height,
          widget.controller.cropRect.width * width,
          widget.controller.cropRect.height * height,
        );

        return GestureDetector(
          onPanStart: (details) {
            _activeHandle = widget.controller.hitTestHandle(
              details.localPosition,
              widget.controller.cropRect,
              width,
              height,
            );

            _startLocal = details.localPosition;
            _startRect = widget.controller.cropRect;

            widget.onGestureStart?.call();
          },

          onPanUpdate: (details) {
            Offset delta = Offset(
              (details.localPosition.dx - _startLocal.dx) / width,
              (details.localPosition.dy - _startLocal.dy) / height,
            );

            delta = widget.controller.clampDeltaForRect(
              _startRect,
              delta,
              _activeHandle,
            );

            Rect rect = _startRect;

            switch (_activeHandle) {
              case CropHandle.move:
                rect = rect.shift(delta);
                break;

              case CropHandle.topLeft:
                rect = Rect.fromLTRB(
                  rect.left + delta.dx,
                  rect.top + delta.dy,
                  rect.right,
                  rect.bottom,
                );
                break;

              case CropHandle.topRight:
                rect = Rect.fromLTRB(
                  rect.left,
                  rect.top + delta.dy,
                  rect.right + delta.dx,
                  rect.bottom,
                );
                break;

              case CropHandle.bottomLeft:
                rect = Rect.fromLTRB(
                  rect.left + delta.dx,
                  rect.top,
                  rect.right,
                  rect.bottom + delta.dy,
                );
                break;

              case CropHandle.bottomRight:
                rect = Rect.fromLTRB(
                  rect.left,
                  rect.top,
                  rect.right + delta.dx,
                  rect.bottom + delta.dy,
                );
                break;

              case CropHandle.none:
                return;
            }

            widget.controller.updateRect(rect);
          },

          child: Stack(
            children: [
              Positioned.fill(
                child: Image(
                  key: ValueKey(widget.controller.cropRect),
                  image: widget.image,
                  fit: BoxFit.cover,
                ),
              ),
              CustomPaint(
                size: Size(width, height),
                painter: CropOverlayPainter(rect: cropRectPx),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: FloatingActionButton(
                  onPressed: _crop,
                  child: const Icon(Icons.check),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
