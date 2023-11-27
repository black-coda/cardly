import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/features/authentication/data/datasources/local/token_storage.dart';
import 'package:cardly/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:cardly/features/authentication/domain/models/token.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


/// Implementation of the [TokenStorage] interface for storing and managing authentication tokens.
class TokenStorageImpl implements TokenStorage {
  static const _tokensKey = "tokens";
  Token? _token;
   
  final FlutterSecureStorage secureStorage;
  final AuthRepositoryImpl authRepositoryImpl;

  /// Constructor to initialize the [TokenStorageImpl] with an [AuthRepositoryImpl] dependency.
  TokenStorageImpl({
    required this.authRepositoryImpl,
    required this.secureStorage,
  });

  

  /// Destroys the stored tokens.
  @override
  Future<void> destroy() async {
    try {
      _token = null;
      await secureStorage.delete(key: _tokensKey);
    } catch (e) {
      // Handle potential exceptions during token destruction.
      e.log();
      debugPrint("Error destroying tokens: $e");
    }
  }

  /// Reads and returns the stored token.
  @override
  Future<Token?> read() async {
    try {
      if (_token != null) {
        return _token!;
      }

      final storedToken = await secureStorage.read(key: _tokensKey);
      if (storedToken != null) {
        _token = Token.fromJson(storedToken);
        return _token!;
      }

      // If the token is not found, consider throwing an exception or providing a default token.
      return null;
    } catch (e) {
      // Handle potential exceptions during token reading.
      e.log();
      debugPrint("Error reading token: $e");
      // Consider throwing a specific exception based on the use case.
      return null;
    }
  }

  /// Saves the provided token.
  @override
  Future<void> save(Token token) async {
    try {
      _token = token;

      await secureStorage.write(key: _tokensKey, value: token.toJson());
      "Token saved 🪲🪲🪲🪲".log();
    } catch (e) {
      // Handle potential exceptions during token saving.
      e.log();
      debugPrint("Error saving token: $e");
      // Consider throwing a specific exception based on the use case.
      throw Exception("Error saving token");
    }
  }

  /// Retrieves and returns the refresh token.
  Future<String?> getRefreshToken() async {
    try {
      final token = await read();
      if (token != null) {
        final refreshToken = token.refreshToken;
        return refreshToken;
      }
      return null;
    } catch (e) {
      // Handle potential exceptions during refresh token retrieval.
      e.log();
      debugPrint("Error getting refresh token: $e");
      return null;
    }
  }

  /// Checks if the access token is valid and attempts to refresh it using the refresh token.
  Future<bool> isTokenValid() async {
    try {
      final token = await read();
      debugPrint("Token: $token");
      token?.log();
      debugPrint("Token 😪: $token");
      if (token == null) {
        return false;
      }
      
      final tokenExpiration = await secureStorage.read(key: _tokensKey);
      if (tokenExpiration == null) {
        return false;
      }
      final Token tokenData = Token.fromJson(tokenExpiration);
      final accessToken = tokenData.accessToken;
      bool hasExpired = JwtDecoder.isExpired(accessToken);
      if (hasExpired) {
        final refreshToken = await getRefreshToken();
        if (refreshToken == null) {
          return false;
        }
        final hasRefreshTokenExpired = JwtDecoder.isExpired(refreshToken);
        if (hasRefreshTokenExpired) {
          return false;
        }
        final newTokenNetworkCall = await activateRefreshToken();
        if (newTokenNetworkCall == null) {
          return false;
        }
        return true;
      }
      return false;
    } catch (e) {
      // Handle potential exceptions during token validation.
      e.log();
      debugPrint("Error validating token: $e");
      return false;
    }
  }

  /// Attempts to activate and retrieve a new access token using the stored refresh token.
  Future<Token?> activateRefreshToken() async {
    try {
      
      final tokenData = await secureStorage.read(key: _tokensKey);

      if (tokenData == null) {
        return null;
      }

      final refreshToken = Token.fromJson(tokenData).refreshToken;
      final newTokenRequest =
          await authRepositoryImpl.getNewToken(refreshToken);
      final Token newToken = Token.fromMap(newTokenRequest);
      await save(newToken);
      return newToken;
    } catch (e) {
      // Handle potential exceptions during refresh token activation.
      e.log();
      debugPrint("Error activating refresh token: $e");
      return null;
    }
  }
}
