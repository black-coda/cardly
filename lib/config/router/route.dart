import 'package:cardly/features/authentication/presentation/screen/login_screen.dart';
import 'package:cardly/features/onboard/presentation/widgets/onboard.dart';
import 'package:cardly/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screen/registration_screen.dart';

class RouteManager {
  static final GlobalKey<NavigatorState> _rootNavigator =
      GlobalKey(debugLabel: "root");
  static final GlobalKey<NavigatorState> _shellNavigator =
      GlobalKey(debugLabel: "shell");

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigator,
    routes: <RouteBase>[
      //* Onboard Screen
      GoRoute(
        name: "onboard",
        path: "/",
        builder: (context, state) => const OnboardScreenController(),
      ),

      //* Login Screen
      GoRoute(
        name: "login",
        path: "/login",
        builder: (context, state) => const LoginScreen(),
      ),

      //* Register Screen
      GoRoute(
        name: "register",
        path: "/register",
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        name: "dashboard",
        path: "/dashboard",
        builder: (context, state) => const DashBoardScreen(),
      )
    ],
  );
}
