import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/config/router/route.dart';
import 'package:cardly/features/authentication/application/service/auth_service.dart';
import 'package:cardly/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:cardly/features/authentication/data/repository/token_storage_impl.dart';
import 'package:cardly/features/authentication/domain/models/token_manager.dart';
import 'package:cardly/features/authentication/presentation/states/auth_state.dart';
import 'package:cardly/utils/auth_result.dart';
import 'package:cardly/utils/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final options = BaseOptions(
  baseUrl: ApiKonstant.baseUrl,
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 3),
);

final dioProvider = Provider<Dio>(
  (ref) {
    return Dio(options);
  },
);

final authRepoImplProvider = Provider<AuthRepositoryImpl>(
  (ref) {
    final dio = ref.watch(dioProvider);
    final tokenManger = ref.watch(tokenManagerProvider);
    return AuthRepositoryImpl(dio: dio, ref: ref, tokenManager: tokenManger);
  },
);

final tokenStorageProvider = Provider<TokenStorageImpl>((ref) {
  final authRepoImpl = ref.watch(authRepoImplProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  return TokenStorageImpl(
    authRepositoryImpl: authRepoImpl,
    secureStorage: secureStorage,
  );
});

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepo = ref.watch(authRepoImplProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  return AuthService(
    authRepositoryImpl: authRepo,
    tokenManager: tokenManager,
  );
});

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService: authService);
});

final isLoadingProvider = Provider<bool>((ref) {
  final authentication = ref.watch(authProvider);
  return authentication.isResultLoading;
});

final goRouterConfigProvider = Provider<GoRouter>((ref) {
  return RouteManager.router;
});

final tokenManagerProvider = Provider<TokenManager>((ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return TokenManager(dio: dio, secureStorage: secureStorage);
});

final isLoggedInProvider = Provider<bool>((ref) {
  // final authentication = ref.watch(authProvider);
  final token = ref.watch(tokenManagerProvider).token?.refreshToken;
  "this is the $token".log();
  if (token != null) {
    bool hasExpired = JwtDecoder.isExpired(token);
    return !hasExpired;
  } else {
    return false;
  }

  // final c = await tokenStorage.isTokenValid();
  // debugPrint("passing here 🗼 $c");
});

final isAuthenticatedProvider = FutureProvider(
  (ref) async {
    final tokenManager = ref.watch(tokenManagerProvider);
    final token = await tokenManager.read();
    if (token != null) {
      final accessToken = token.accessToken;
      debugPrint("accessToken: $accessToken");
      final refreshToken = token.refreshToken;
      debugPrint("refreshToken: $refreshToken");
      bool hasAccessTokenExpired = JwtDecoder.isExpired(accessToken);
      if (hasAccessTokenExpired) {
        bool hasRefreshTokenExpired = JwtDecoder.isExpired(refreshToken);
        if (hasRefreshTokenExpired) {
          return false;
        } else {
          await tokenManager.refresh();
          return true;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  },
);
