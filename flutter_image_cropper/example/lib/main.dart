import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_cropper/flutter_image_cropper.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CropExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CropExample extends StatefulWidget {
  const CropExample({super.key});

  @override
  State<CropExample> createState() => _CropExampleState();
}

class _CropExampleState extends State<CropExample> {
  final controller = CropController();
  File? croppedFile;
  CropMode _mode = CropMode.free;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pure Dart Image Cropper')),
      body: Column(
        children: [
          Expanded(
            child: CropWidget(
              image: const NetworkImage('https://picsum.photos/800/600'),
              controller: controller,
              destinationDir: getTemporaryDirectory(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CropModeButton(
                    label: 'Free',
                    icon: Icons.open_in_full,
                    selected: _mode == CropMode.free,
                    onTap: () {
                      setState(() {
                        _mode = CropMode.free;
                        controller.setAspectRatio(null);
                      });
                    },
                  ),
                  _CropModeButton(
                    label: '1:1',
                    selected: _mode == CropMode.ratio1x1,
                    onTap: () {
                      setState(() {
                        _mode = CropMode.ratio1x1;
                        controller.setAspectRatio(1);
                      });
                    },
                  ),
                  _CropModeButton(
                    label: '4:3',
                    selected: _mode == CropMode.ratio4x3,
                    onTap: () {
                      setState(() {
                        _mode = CropMode.ratio4x3;
                        controller.setAspectRatio(4 / 3);
                      });
                    },
                  ),
                  _CropModeButton(
                    label: '16:9',
                    selected: _mode == CropMode.ratio16x9,
                    onTap: () {
                      setState(() {
                        _mode = CropMode.ratio16x9;
                        controller.setAspectRatio(16 / 9);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum CropMode { free, ratio1x1, ratio4x3, ratio16x9 }

class _CropModeButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _CropModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.black : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
