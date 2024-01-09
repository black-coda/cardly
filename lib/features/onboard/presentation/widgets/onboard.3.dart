import 'package:cardly/config/theme/color.dart';
import 'package:cardly/features/authentication/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoardScreen3 extends StatelessWidget {
  const OnBoardScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Column(
              children: [
                Image.asset("assets/images/2.png"),
                const SizedBox(height: 24),
                Text(
                  "Real-time insight into your spending",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),
                // "Create account" button
                CustomButton(
                  color: BrandColor.primaryColorShade3,
                  text: "Create account",
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                CustomButton(
                  color: BrandColor.white,
                  textColor: BrandColor.primaryColor,
                  text: "Sign in",
                  onPressed: () {
                    context.go('/login');
                  },
                ),
                const SizedBox(height: 38),
                // "Forgot password" link
              ],
            ),
          )
        ],
      ),
    );
  }
}
