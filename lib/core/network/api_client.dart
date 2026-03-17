import 'package:dio/dio.dart';
import '../error/exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Response> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      return ServerException();
    } else {
      return NetworkException();
    }
  }
}
