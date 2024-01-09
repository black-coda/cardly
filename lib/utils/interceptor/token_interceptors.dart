import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/features/authentication/domain/models/token.dart';
import 'package:cardly/features/authentication/domain/models/token_manager.dart';
import 'package:cardly/features/authentication/presentation/controllers/controllers.dart';
import 'package:cardly/features/authentication/presentation/screen/login_screen.dart';
import 'package:cardly/utils/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenInterceptors extends Interceptor {
  final Ref ref;
  final Dio dio;
  final TokenManager tokenManager;

  // Flag to prevent multiple concurrent token refreshes
  bool isRefreshing = false;

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

    if (options.path != ApiKonstant.register) {
      if (getTokenCall != null) {
        // getTokenCall.accessToken.log();
        options.headers["Authorization"] = "Bearer ${getTokenCall.accessToken}";
        // options.data["refresh"] = getTokenCall.refreshToken;
      }
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
    ('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}  and ${err.requestOptions.headers}')
        .log();

    // Check if the error is due to an expired token
    if (err.requestOptions.path != ApiKonstant.register &&
        err.requestOptions.headers.containsKey("Authorization") &&
        err.response?.statusCode == 401) {
      // Check if a refresh is not already in progress
      if (!isRefreshing) {
        isRefreshing = true;

        final refreshTokenReq = await tokenManager.refresh();
        if (refreshTokenReq != null) {
          // Retry the original request with the new token
          err.requestOptions.headers["Authorization"] =
              refreshTokenReq.accessToken;
          final response = await dio.request(
            err.requestOptions.path,
            // options: err.requestOptions.,
          );
          // Continue with the refreshed token
          handler.resolve(Response(
            requestOptions: err.requestOptions,
            data: response.data,
            headers: response.headers,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
          ));
        } else {
          // Error refreshing token
          ('Error refreshing token').log();

          _redirectUserToLoginScreen();
        }

        isRefreshing = false;
      }
    }

 

    super.onError(err, handler);
  }

  void _redirectUserToLoginScreen() {
    ref.watch(goRouterConfigProvider).push("/login");
  }

  Future<Token?> getTokens() async {
    final token = await tokenManager.read();
    if (token != null) {
      return token;
    }
    return null;
  }
}
