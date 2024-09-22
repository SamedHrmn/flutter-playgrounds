import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:low_light_enhancer_client/image_select_view.dart';
import 'package:low_light_enhancer_client/service/dio_client.dart';
import 'package:low_light_enhancer_client/utils/image_util.dart';
import 'package:low_light_enhancer_client/utils/permission_util.dart';

mixin ImageSelectViewMixin on State<ImageSelectView> {
  final ValueNotifier<EnhanceImageState> enhanceImageState = ValueNotifier(EnhanceImageState());
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

    enhanceImageState.value = EnhanceImageState(galleryImage: image);
    await _enhanceImage();
  }

  Future<void> _enhanceImage() async {
    enhanceImageState.value = enhanceImageState.value.copyWith(status: EnhanceImageFetchStatus.loading);

    try {
      if (enhanceImageState.value.galleryImage == null) {
        enhanceImageState.value = EnhanceImageState();
        return;
      }

      final image = await _dioClient.enhanceImage(enhanceImageState.value.galleryImage!);
      if (image != null) {
        enhanceImageState.value = enhanceImageState.value.copyWith(
          outputImage: image.data["result_image"],
          status: EnhanceImageFetchStatus.loaded,
        );
      }
    } catch (e) {
      log(e.toString(), error: e);
      enhanceImageState.value = EnhanceImageState(status: EnhanceImageFetchStatus.error);
    }
  }
}

class EnhanceImageState {
  final String? galleryImage;
  final String? outputImage;
  final EnhanceImageFetchStatus status;

  EnhanceImageState({
    this.galleryImage,
    this.outputImage,
    this.status = EnhanceImageFetchStatus.initial,
  });

  EnhanceImageState copyWith({
    String? galleryImage,
    String? outputImage,
    EnhanceImageFetchStatus? status,
  }) {
    return EnhanceImageState(
      galleryImage: galleryImage ?? this.galleryImage,
      outputImage: outputImage ?? this.outputImage,
      status: status ?? this.status,
    );
  }
}

enum EnhanceImageFetchStatus {
  initial,
  loading,
  loaded,
  error,
}
