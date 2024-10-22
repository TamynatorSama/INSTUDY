import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final String token;
  const TokenInterceptor(this.token);
  @override
  void onRequest(options, handler) {
    options.headers.addAll({"Authorization": "Bearer $token"});
    return handler.next(options);
  }
}
