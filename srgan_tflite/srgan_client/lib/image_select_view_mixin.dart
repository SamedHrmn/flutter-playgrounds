import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:srgan_client/image_select_view.dart';
import 'package:srgan_client/service/dio_client.dart';
import 'package:srgan_client/utils/image_util.dart';
import 'package:srgan_client/utils/permission_util.dart';

mixin ImageSelectViewMixin on State<ImageSelectView> {
  final ValueNotifier<UpscaledImageState> upscaledImageState = ValueNotifier(UpscaledImageState());
  late final DioClient _dioClient;

  @override
  void initState() {
    super.initState();
    final dio = Dio(
      BaseOptions(
        headers: {'Connection': 'Keep-Alive'},
        persistentConnection: true,
      ),
    );
    dio.interceptors.add(LogInterceptor(responseBody: true));

    _dioClient = DioClient(dio: dio);
  }

  Future<void> pickGalleryImageAsBase64() async {
    final hasGranted = await PermissionUtil.checkGalleryPermission();
    if (!hasGranted) return;

    final image = await ImageUtil.pickImageFromGalleryAsBase64();
    if (image == null) return;

    upscaledImageState.value = UpscaledImageState(galleryImage: image);
    await _upscaleImage();
  }

  Future<void> _upscaleImage() async {
    upscaledImageState.value = upscaledImageState.value.copyWith(status: UpscaledImageFetchStatus.loading);

    try {
      if (upscaledImageState.value.galleryImage == null) {
        upscaledImageState.value = UpscaledImageState();
        return;
      }

      final image = await _dioClient.upscaleImage(upscaledImageState.value.galleryImage!);
      if (image != null) {
        upscaledImageState.value = upscaledImageState.value.copyWith(
          outputImage: image.data["result_image"],
          status: UpscaledImageFetchStatus.loaded,
        );
      }
    } catch (e) {
      log(e.toString(), error: e);
      upscaledImageState.value = UpscaledImageState(status: UpscaledImageFetchStatus.error);
    }
  }
}

class UpscaledImageState {
  final String? galleryImage;
  final String? outputImage;
  final UpscaledImageFetchStatus status;

  UpscaledImageState({
    this.galleryImage,
    this.outputImage,
    this.status = UpscaledImageFetchStatus.initial,
  });

  UpscaledImageState copyWith({
    String? galleryImage,
    String? outputImage,
    UpscaledImageFetchStatus? status,
  }) {
    return UpscaledImageState(
      galleryImage: galleryImage ?? this.galleryImage,
      outputImage: outputImage ?? this.outputImage,
      status: status ?? this.status,
    );
  }
}

enum UpscaledImageFetchStatus {
  initial,
  loading,
  loaded,
  error,
}
