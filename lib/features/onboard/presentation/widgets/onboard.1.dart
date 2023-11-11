/// This Dart file defines the `OnBoard1` class, which represents the first screen of an onboarding flow.
/// It includes a circular image, a headline, a "Create account" button, and a "Forgot password" link.

import 'package:cardly/config/theme/color.dart';
import 'package:cardly/features/authentication/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

/// The `OnBoardScreen1` class is a stateless widget representing the first screen of the onboarding flow.
class OnBoardScreen1 extends StatelessWidget {
  /// Constructor for the `OnBoard1` class.
  const OnBoardScreen1({super.key});

  /// Builds the UI for the onboarding screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColor.white,
        elevation: 0,
        actions: [
          // Skip button in the app bar
          TextButton(
            onPressed: () {},
            child: const Text(
              "Skip",
              style: TextStyle(
                color: BrandColor.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BrandColor.primaryColorShade1.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset("assets/images/3x/onboard.png"),
                ),
                const SizedBox(height: 56),
                // Headline text
                const Text(
                  "All your accounts\nIn one place",
                  style: TextStyle(
                    color: BrandColor.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                const SizedBox(height: 32),
                // "Create account" button
                const CustomButton(
                  color: BrandColor.primaryColorShade3,
                  text: "Create account",
                ),
                const SizedBox(height: 32),
                // "Forgot password" link
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot password",
                      style: TextStyle(color: BrandColor.primaryColor),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
