import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/features/authentication/domain/models/token.dart';
import 'package:cardly/features/authentication/domain/models/token_manager.dart';
import 'package:cardly/features/authentication/presentation/controllers/controllers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenInterceptors extends Interceptor {
  final Ref ref;
  final Dio dio;
  final TokenManager tokenManager;

  TokenInterceptors({
    required this.ref,
    required this.dio,
    required this.tokenManager,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    ('REQUEST[${options.method}] => PATH: ${options.path}').log();
    options.extra.toString().log();
    final getTokenCall = await getTokens();
    if (options.headers.containsKey("Authorization")) {
      if (getTokenCall != null) {
        options.headers["Authorization"] = "Bearer ${getTokenCall.accessToken}";
      }
    }

    if (getTokenCall != null) {
      options.headers["Authorization"] = "Bearer ${getTokenCall.accessToken}";
      // options.data["refresh"] = getTokenCall.refreshToken;
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}')
        .log();
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    ('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}')
        .log();

    if (err.requestOptions.headers.containsKey("Authorization")) {
      if (err.response?.statusCode == 401) {
        final getTokenCall = await getTokens();
        if (getTokenCall != null) {
          bool hasExpired = JwtDecoder.isExpired(getTokenCall.accessToken);
          hasExpired.toString().log();
        }
        final refreshTokenReq = await tokenManager.refresh();
        if (refreshTokenReq != null) {
          err.requestOptions.headers["Authorization"] =
              refreshTokenReq.accessToken;
        } else {
          final router = ref.watch(goRouterConfigProvider);
          router.pushReplacementNamed("login");
        }
      }
    }
    super.onError(err, handler);
  }

  Future<Token?> getTokens() async {
    final token = await tokenManager.read();
    if (token != null) {
      return token;
    }
    return null;
  }
}
