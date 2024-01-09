/// This Dart file defines the `OnBoard1` class, which represents the first screen of an onboarding flow.
/// It includes a circular image, a headline, a "Create account" button, and a "Forgot password" link.

import 'package:cardly/config/theme/color.dart';
import 'package:cardly/features/authentication/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The `OnBoardScreen1` class is a stateless widget representing the first screen of the onboarding flow.
class OnBoardScreen1 extends StatelessWidget {
  /// Constructor for the `OnBoard1` class.
  const OnBoardScreen1({super.key});

  /// Builds the UI for the onboarding screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular image container
                Container(
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    color: BrandColor.primaryColorShade1.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset("assets/images/3x/onboard.png"),
                ),
                const SizedBox(height: 56),
                // Headline text
                Column(
                  children: [
                    Text(
                      "All your accounts\nIn one place",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    const SizedBox(height: 32),
                    // "Create account" button
                    const CustomButton(
                      color: BrandColor.primaryColorShade3,
                      text: "Create account",
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      color: BrandColor.primaryColorShade3,
                      text: "Sign in",
                      onPressed: () {
                        context.go('/login');
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
                // "Forgot password" link
              ],
            ),
          ),
        ],
      ),
    );
  }
}
