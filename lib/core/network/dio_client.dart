import 'package:dio/dio.dart';

class DioClient {
  // Singleton pattern (Optional/Dependency Injection)
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio _dio;
  DioClient._internal(){
    _dio = Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      },
    ));

    // Add Log Interceptor to debug API easier
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('DIO LOG: $obj'),
    ));
  }

  Dio get dio => _dio;
}