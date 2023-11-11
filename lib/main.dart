import 'package:cardly/config/theme/theme.dart';
import 'package:cardly/features/authentication/presentation/widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: AppEntry()));
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeCard.initialThemeData,
      home: const LoginScreen(),
    );
  }
}
