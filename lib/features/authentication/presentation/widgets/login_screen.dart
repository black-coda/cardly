/// `LoginScreen` is a Flutter widget representing the login screen of the application.
/// It provides a user interface for users to enter their login credentials and initiate the login process.

import 'package:cardly/config/theme/color.dart';
import 'package:cardly/features/authentication/presentation/widgets/custom_button.dart';
import 'package:cardly/utils/forms/dynamic_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The `LoginScreen` class extends `ConsumerStatefulWidget`, indicating that it relies on the Riverpod library for state management.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

/// The `_LoginScreenState` class represents the state for the `LoginScreen` widget.
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final isNonPasswordField = false;

  final AuthValidators authValidators = AuthValidators();

  bool obscureText = true;

  // Controllers
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // Focus nodes
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    // Dispose of controllers
    emailController.dispose();
    passwordController.dispose();

    // Dispose of focus nodes
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  /// Toggles the visibility of the password text.
  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: BrandColor.primaryColorShade2,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome message
                    const Text(
                      "Welcome back, Monday 👋",
                      style: TextStyle(
                        color: BrandColor.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Subtitle
                    const Text(
                      "We're glad you're back. To use your account,\nplease login.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 56),
                    // Password input field
                    DynamicInputWidget(
                      isNonPasswordField: isNonPasswordField,
                      controller: passwordController,
                      obscureText: obscureText,
                      focusNode: passwordFocusNode,
                      labelText: "Enter Password",
                      textInputAction: TextInputAction.done,
                      toggleObscureText: toggleObscureText,
                    ),
                    const SizedBox(height: 32),
                    // Login button
                    const CustomButton(
                      color: BrandColor.primaryColorShade3,
                      text: "Login",
                    ),
                    const SizedBox(height: 32),
                    // Forgot password link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password tap
                        },
                        child: const Text(
                          "Forgot password",
                          style: TextStyle(
                            fontFamily: "SpaceMono",
                            color: BrandColor.primaryColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
