import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

enum BackgroundMode { none, dominantColor, blur }

class CropResultView extends StatefulWidget {
  const CropResultView({super.key, required this.image});

  final File image;

  @override
  State<CropResultView> createState() => _CropResultViewState();
}

class _CropResultViewState extends State<CropResultView> {
  BackgroundMode _mode = BackgroundMode.blur;
  Color? _dominantColor;
  bool _isCalculatingDominant = false;

  void _setMode(BackgroundMode mode) {
    if (_mode == mode) return;

    setState(() => _mode = mode);

    if (mode == BackgroundMode.dominantColor &&
        _dominantColor == null &&
        !_isCalculatingDominant) {
      _calculateDominantColor();
    }
  }

  Future<void> _calculateDominantColor() async {
    _isCalculatingDominant = true;

    final image = await decodeImageFromList(await widget.image.readAsBytes());

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      const Rect.fromLTWH(0, 0, 20, 20),
      Paint(),
    );

    final picture = recorder.endRecording();
    final small = await picture.toImage(20, 20);
    final bytes = await small.toByteData();

    final pixels = bytes!.buffer.asUint32List();

    int r = 0, g = 0, b = 0;

    for (final p in pixels) {
      r += (p >> 16) & 0xFF;
      g += (p >> 8) & 0xFF;
      b += p & 0xFF;
    }

    final count = pixels.length;

    if (!mounted) return;

    setState(() {
      _dominantColor = Color.fromARGB(
        255,
        (r / count).round(),
        (g / count).round(),
        (b / count).round(),
      );
      _isCalculatingDominant = false;
    });
  }

  @override
  void didUpdateWidget(covariant CropResultView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.image.path != widget.image.path) {
      _dominantColor = null;
      _isCalculatingDominant = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(),
          _buildForegroundImage(),
          _buildBottomControls(), // 👈 yeni
        ],
      ),
    );
  }

  Widget _buildBackground() {
    switch (_mode) {
      case BackgroundMode.none:
        return Container(color: Colors.black);

      case BackgroundMode.blur:
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.file(widget.image, fit: BoxFit.cover),
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ],
        );

      case BackgroundMode.dominantColor:
        if (_dominantColor == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(color: _dominantColor);
    }
  }

  Widget _buildForegroundImage() {
    return Center(
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Image.file(widget.image),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomItem(
                icon: Icons.crop_original,
                label: 'None',
                selected: _mode == BackgroundMode.none,
                onTap: () => _setMode(BackgroundMode.none),
              ),
              _BottomItem(
                icon: Icons.palette,
                label: 'Color',
                selected: _mode == BackgroundMode.dominantColor,
                onTap: () => _setMode(BackgroundMode.dominantColor),
              ),
              _BottomItem(
                icon: Icons.blur_on,
                label: 'Blur',
                selected: _mode == BackgroundMode.blur,
                onTap: () => _setMode(BackgroundMode.blur),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white54;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
