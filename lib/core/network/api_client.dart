import 'package:dio/dio.dart';

class ApiClient {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://newsapi.org/v2',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await dio.get(path, queryParameters: queryParameters);
    return response.data;
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await dio.post(path, data: data);
  }
}
