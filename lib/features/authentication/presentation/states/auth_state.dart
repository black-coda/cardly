import 'package:cardly/features/authentication/application/service/auth_service.dart';
import 'package:cardly/features/authentication/domain/models/user.dart';
import 'package:cardly/features/authentication/presentation/screen/login_screen.dart';
import 'package:cardly/main.dart';
import 'package:cardly/utils/auth_result.dart';
import 'package:cardly/utils/component/loading/loading_screen.dart';
import 'package:cardly/utils/constant/animation.dart';
import 'package:cardly/utils/constant/message_dialogue.dart';
import 'package:flutter/foundation.dart' show immutable, debugPrint;
import 'package:flutter/material.dart'
    show BuildContext, MaterialPageRoute, Navigator;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

@immutable
class AuthState {
  final Result? result;
  final bool isResultLoading;

  const AuthState({
    required this.result,
    required this.isResultLoading,
  });

  const AuthState.unknown()
      : result = null,
        isResultLoading = false;

  AuthState copyWithIsResultLoading(bool isResultLoading) {
    return AuthState(
      result: result,
      isResultLoading: isResultLoading,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthState &&
          result == other.result &&
          isResultLoading == other.isResultLoading);

  @override
  int get hashCode => Object.hash(
        result,
        isResultLoading,
      );

  @override
  String toString() {
    return 'AuthState(result: $result, isResultLoading: $isResultLoading)';
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier({required this.authService})
      : super(const AuthState.unknown());
  // To implement check for token on app start

  final AuthService authService;

  Future<void> logOut(BuildContext context) async {
    state.copyWithIsResultLoading(true);
    await authService.logOut();
    Future.delayed(const Duration(seconds: 2), () {
      context.replaceNamed("onboard");
    });
  }

  Future<void> login(UserModel userModel, BuildContext context) async {
    state = state.copyWithIsResultLoading(true);
    final request = await authService.logUserIn(userModel);
    request.fold(
      (Failure failure) {
        state = AuthState(
          result: Failure(message: failure.message),
          isResultLoading: false,
        );

        LoadingScreen.instance().hide();

        //* As soon as it stops loading

        MessageDialogue.authMessage(
          context: context,
          message: failure.message,
          link: AnimationConstant.errorPath,
        );

        Future.delayed(const Duration(seconds: 2), () {
          context.pop();
          Navigator.of(context).pop();
        });

        return;
      },
      (success) {
        state = AuthState(
          result: Success(data: success.data),
          isResultLoading: false,
        );

        debugPrint("Successfully logged in");
        MessageDialogue.authMessage(
          context: context,
          message: "Welcome Back! 😁",
          link: AnimationConstant.successPath,
        );

        Future.delayed(const Duration(seconds: 2), () {
          context.pop();
          context.go("/dashboard");
        });

        return;
      },
    );
  }

  Future<void> register(UserModel userModel, BuildContext context) async {
    state = state.copyWithIsResultLoading(true);
    final request = await authService.register(userModel);
    request.fold(
      (failure) {
        state = AuthState(
          result: Failure(message: failure.message),
          isResultLoading: false,
        );

        LoadingScreen.instance().hide();

        //* As soon as it stops loading

        MessageDialogue.authMessage(
            context: context,
            message: failure.message,
            link: AnimationConstant.errorPath);

        Navigator.of(context).pop();

        return;
      },
      (success) {
        state = AuthState(
          result: Success(data: success.data),
          isResultLoading: false,
        );

        debugPrint("Successfully registered");
        MessageDialogue.authMessage(
            context: context,
            message: "Registration successful 🚀",
            link: AnimationConstant.successPath);

        Future.delayed(
          const Duration(seconds: 3),
          () {
            // Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const DashBoardScreen();
                },
              ),
            );
          },
        ).then(
          (_) {},
        );

        return;
      },
    );
  }
}
