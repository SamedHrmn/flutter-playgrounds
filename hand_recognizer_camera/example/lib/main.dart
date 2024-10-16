import 'package:flutter/material.dart';
import 'hand_landmarks_painter.dart';
import 'preview_view_manager.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PreviewView(),
    );
  }
}

class PreviewView extends StatefulWidget {
  const PreviewView({super.key});

  @override
  State<PreviewView> createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> with PreviewViewManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: hasCameraPermission ? _cameraPreviewView() : _noPermissionView(),
        ),
      ),
    );
  }

  Widget _cameraPreviewView() {
    return textureId == null
        ? const CircularProgressIndicator()
        : LayoutBuilder(
            builder: (context, constraints) {
              scaleFactorX = constraints.maxWidth.toDouble();
              scaleFactorY = constraints.maxHeight.toDouble();

              return Stack(
                children: [
                  Texture(textureId: textureId!),
                  if (resultBundle != null) ...{
                    CustomPaint(
                      painter: HandLandmarksPainter(
                        resultBundle: resultBundle!,
                        scaleFactorX: scaleFactorX,
                        scaleFactorY: scaleFactorY,
                      ),
                    ),
                    Positioned(
                      top: 16.0,
                      left: 16.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Inference Time: ${resultBundle!.inferenceTime} ms',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  }
                ],
              );
            },
          );
  }

  Widget _noPermissionView() {
    return const Center(
      child: Text("You need to access camera permission for using this app."),
    );
  }
}
