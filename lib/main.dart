import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/config/theme/theme.dart';
import 'package:cardly/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:cardly/features/authentication/presentation/screen/login_screen.dart';
import 'package:cardly/features/authentication/presentation/screen/registration_screen.dart';
import 'package:cardly/features/onboard/presentation/widgets/onboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/authentication/presentation/controllers/controllers.dart';
import 'utils/component/loading/loading_screen.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(goRouterConfigProvider);
    ref.watch(isAuthenticatedProvider).when(
      data: (authenticated) {
        debugPrint("is it authenticated: $authenticated");
        if (authenticated) {
          route.go("/dashboard");
        } else {
          route.go("/");
        }
      },
      error: (error, stackTrace) {
        debugPrint(error.toString());
        route.goNamed("onboard");
      },
      loading: () {
        // LoadingScreen.instance().show(
        //   context: context,
        // );
        const LoaderScreen();
      },
    );
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
                  await ref.watch(authProvider.notifier).logOut(context);
                },
                child: const Text("Logout"),
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
