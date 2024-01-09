import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/features/authentication/data/datasources/local/token_storage.dart';
import 'package:cardly/features/authentication/domain/models/token.dart';
import 'package:cardly/utils/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager implements TokenStorage {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
  static const _tokenKey = "tokens";
  Token? _token;

  Token? get token => _token;

  TokenManager({required this.dio, required this.secureStorage});

  @override
  Future<void> destroy() {
    _token = null;
    return secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<Token?> read() async {
    try {
      if (_token != null) {
        return _token;
      }
      final json = await secureStorage.read(key: _tokenKey);
      if (json != null) {
        final token = Token.fromJson(json);
        return token;
      }
      return null;
    } on PlatformException catch (e) {
      "Error reading token: $e".log();
      return null;
    }
  }

  @override
  Future<void> save(Token token) {
    _token = token;

    return secureStorage.write(key: _tokenKey, value: token.toJson());
  }

  @override
  Future<Token?> refresh() async {
    try {
      final getToken = await read();
      if (getToken != null) {
        final oldRefreshToken = getToken.refreshToken;
        final request = await dio.post(
          ApiKonstant.refresh,
          data: {"refresh": oldRefreshToken},
        );
        if (request.statusCode == 200) {
          final newToken = Token.fromMap(request.data);
          await save(request.data);
          return newToken;
        }
        return null;
      }
      return null;
    } catch (e) {
      e.log();
      return null;
    }
  }
}
