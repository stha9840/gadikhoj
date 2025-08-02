import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.contains('/login') || options.path.contains('/register')) {
      return handler.next(options);
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token'); 

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue with the request
    return handler.next(options);
  }
}