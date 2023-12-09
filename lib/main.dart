import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/config/theme/theme.dart';
import 'package:cardly/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:cardly/features/authentication/presentation/screen/login_screen.dart';
import 'package:cardly/features/authentication/presentation/screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/authentication/presentation/controllers/controllers.dart';
import 'utils/component/loading/loading_screen.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: AppEntry(),
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
        builder: (_, ref, child) {
          //* Installs loading screen whenever state is Loading()
          // ref.listen<bool>(
          //   isLoadingProvider,
          //   (_, isLoading) {
          //     if (isLoading) {
          //       LoadingScreen.instance().show(
          //         context: context,
          //       );
          //     } else {
          //       LoadingScreen.instance().hide();
          //     }
          //   },
          // );

          final route = ref.watch(goRouterConfigProvider);
          final isLoggedIn = ref.watch(isLoggedInProvider);
          isLoggedIn.log();

          if (isLoggedIn) {
            return const DashBoardScreen();
          } else {
            return const RegistrationScreen();
          }
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

    // ref.watch(isLoggedInProvider).when(
    //   data: (loggedIn) {
    //     if (loggedIn) {
    //       route.goNamed("dashboard");
    //     } else {
    //       route.goNamed("login");
    //     }
    //   },
    //   error: (error, stackTrace) {
    //     error.toString().log();
    //   },
    //   loading: () {
    //     "loading".log();
    //     return const LoaderScreen();
    //   },
    // );
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
      body: Consumer(
        builder: (context, ref, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () async {
                  await ref.watch(authRepoImplProvider).listAllUser();
                },
                child: const Text("Get All User"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
                },
                child: const Text("Login"),
              ),
            ],
          );
        },
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
