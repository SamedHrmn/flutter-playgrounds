import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:srgan_flutter/srgan_flutter.dart';
import 'package:srgan_flutter/srgan_flutter_platform_interface.dart';

import 'pick_image_view_manager.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PickImageView(),
    );
  }
}

class PickImageView extends StatefulWidget {
  const PickImageView({super.key});

  @override
  State<PickImageView> createState() => _PickImageViewState();
}

class _PickImageViewState extends State<PickImageView> with PickImageViewManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SRGAN Enhancer Plugin'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async => await pickImageFromGallery(),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: pickedImageData != null
                        ? Image.memory(
                            pickedImageData!,
                            fit: BoxFit.cover,
                          )
                        : const Center(child: Text("Tap to pick image")),
                  ),
                ),
              ),
              if (pickedImageData != null) ...{
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: ElevatedButton(
                    child: const Text("Enhance image"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
                    onPressed: () async => await enhanceImage(),
                  ),
                ),
              },
              Expanded(
                child: Card(
                  child: switch (srganResultState) {
                    SrganResultState.initial => const SizedBox(),
                    SrganResultState.loading => const Center(child: CircularProgressIndicator()),
                    SrganResultState.error => const Text("Error"),
                    SrganResultState.success => Image.memory(
                        srganResult!.imageData!,
                        fit: BoxFit.cover,
                      )
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
