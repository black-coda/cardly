import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/config/router/route.dart';
import 'package:cardly/features/authentication/application/service/auth_service.dart';
import 'package:cardly/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:cardly/features/authentication/data/repository/token_storage_impl.dart';
import 'package:cardly/features/authentication/presentation/states/auth_state.dart';
import 'package:cardly/utils/auth_result.dart';
import 'package:cardly/utils/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

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
    return AuthRepositoryImpl(dio: dio);
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
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthService(
    authRepositoryImpl: authRepo,
    tokenStorageImpl: tokenStorage,
  );
});

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService: authService);
});

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authentication = ref.watch(authProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);

  final c = await tokenStorage.isTokenValid();
  debugPrint("passing here 🗼 $c");

  return authentication.result == const Success();
});

final isLoadingProvider = Provider<bool>((ref) {
  final authentication = ref.watch(authProvider);
  return authentication.isResultLoading;
});

final goRouterConfigProvider = Provider<GoRouter>((ref) {
  return RouteManager.router;
});
