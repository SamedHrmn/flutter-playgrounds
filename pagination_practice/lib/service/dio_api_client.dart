import 'package:dio/dio.dart';

class DioApiClient {
  late final Dio _dio;

  DioApiClient({Dio? dio}) {
    _dio = dio ?? Dio();
  }

  Future<T?> fetch<T>(
      {required String path,
      Object? data,
      Map<String, dynamic>? queryParams}) async {
    final response = await _dio.get<T?>(
      path,
      data: data,
      queryParameters: queryParams,
    );
    return response.data;
  }
}
