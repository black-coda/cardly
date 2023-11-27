import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/config/theme/theme.dart';
import 'package:cardly/features/authentication/presentation/screen/login_screen.dart';
import 'package:cardly/features/authentication/presentation/screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/authentication/presentation/controllers/controllers.dart';
import 'utils/component/loading/loading_screen.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    //  final routes = ref.watch(goRouterProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeCard.initialThemeData,
      home: Consumer(
        builder: (context, ref, child) {
          //* Install loading screen whenever state is Loading()

          final route = ref.watch(goRouterConfigProvider);
          final isLoggedIn = ref.watch(isLoggedInProvider);

          ref.listen<bool>(
            isLoadingProvider,
            (_, isLoading) {
              if (isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                );
              } else {
                LoadingScreen.instance().hide();
              }
            },
          );

          isLoggedIn.when(
            data: (loggedIn) {
              if (loggedIn) {
                route.goNamed("dashboard");
              } else {
                route.goNamed("login");
              }
            },
            error: (error, stackTrace) {
              error.toString().log();
            },
            loading: () {
              "loading".log();
              return const LoaderScreen();
            },
          );

          return const Scaffold(
            body: Center(
              child: Text("Loading"),
            ),
          );
        },
      ),
    );
  }
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<bool>(
      isLoadingProvider,
      (_, isLoading) {
        if (isLoading) {
          LoadingScreen.instance().show(
            context: context,
          );
        } else {
          LoadingScreen.instance().hide();
        }
      },
    );
    ref.watch(isLoggedInProvider).log();
    final route = ref.watch(goRouterConfigProvider);

    ref.watch(isLoggedInProvider).when(
      data: (loggedIn) {
        if (loggedIn) {
          route.goNamed("dashboard");
        } else {
          route.goNamed("login");
        }
      },
      error: (error, stackTrace) {
        error.toString().log();
      },
      loading: () {
        "loading".log();
        return const LoaderScreen();
      },
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeCard.initialThemeData,
      routerConfig: route,
    );
  }
}

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DashBoard"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("DashBoard"),
      ),
    );
  }
}

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
