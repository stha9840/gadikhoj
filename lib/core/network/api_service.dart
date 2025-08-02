import 'package:dio/dio.dart';
import 'package:finalyearproject/app/constant/api_endpoints.dart';
import 'package:finalyearproject/core/network/api_interceptor.dart';
import 'package:finalyearproject/core/network/dio_error_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;

  Dio get dio => _dio;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.serverAddress
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

    _dio.interceptors.addAll([
      AuthInterceptor(), 

      DioErrorInterceptor(),

      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    ]);
  }
}