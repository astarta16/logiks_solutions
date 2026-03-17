import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../core/network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.restful-api.dev/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  sl.registerLazySingleton(() => dio);

  sl.registerLazySingleton(() => ApiClient(sl()));
}
