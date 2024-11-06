import 'dart:developer';

import 'package:dio/dio.dart';

abstract class ISrganClient {
  Future<Response?> upscaleImage(String inputImageBase64);
}

class DioClient implements ISrganClient {
  static DioClient? _instance;
  late final Dio _dio;

  final baseUrl = 'http://10.0.2.2:8080';

  DioClient._(Dio dio) : _dio = dio;

  factory DioClient({required Dio dio}) {
    return _instance ??= DioClient._(dio);
  }

  @override
  Future<Response?> upscaleImage(String inputImageBase64) async {
    try {
      return _dio.post('$baseUrl/upscaleImage', data: {
        'input_image_base64': inputImageBase64,
      });
    } catch (e) {
      log(e.toString(), error: e);
      return null;
    }
  }
}
