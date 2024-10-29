import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:srgan_flutter/srgan_flutter.dart';
import 'package:srgan_flutter/srgan_flutter_platform_interface.dart';
import 'package:srgan_flutter_example/main.dart';

mixin PickImageViewManager on State<PickImageView> {
  Uint8List? pickedImageData;
  SrganResultState srganResultState = SrganResultState.initial;
  final srganFlutter = SrganFlutter();
  SrganResult? srganResult;

  @override
  void initState() {
    super.initState();

    srganFlutter.initializeEnhancer();

    askGalleryPermission().then((hasPermission) async {
      if (hasPermission) await pickImageFromGallery();
    });
  }

  void updateState(SrganResultState state) {
    setState(() {
      srganResultState = state;
    });
  }

  void updatePickedImage(Uint8List data) {
    setState(() {
      pickedImageData = data;
    });
  }

  Future<void> initializeEnhancer() async {
    await srganFlutter.initializeEnhancer();
  }

  Future<bool> askGalleryPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      final hasGranted = await Permission.storage.isGranted;
      if (hasGranted) return true;

      final status = await Permission.storage.request();
      return status.isGranted;
    } else {
      final hasGranted = await Permission.photos.isGranted;
      if (hasGranted) return true;

      final status = await Permission.photos.request();
      return status.isGranted;
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      updatePickedImage(bytes);
    }
  }

  Future<void> enhanceImage() async {
    if (pickedImageData == null) return;

    try {
      updateState(SrganResultState.loading);
      srganResult = await srganFlutter.enhanceImage(inputData: pickedImageData!);
      updateState(SrganResultState.success);
    } catch (e) {
      updateState(SrganResultState.error);
      srganResult = null;
    }
  }
}

enum SrganResultState {
  initial,
  loading,
  success,
  error,
}
