/// `LoginScreen` is a Flutter widget representing the login screen of the application.
/// It provides a user interface for users to enter their login credentials and initiate the login process.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardly/config/theme/color.dart';
import 'package:cardly/features/authentication/domain/models/user.dart';
import 'package:cardly/features/authentication/presentation/controllers/controllers.dart';
import 'package:cardly/features/authentication/presentation/widgets/custom_button.dart';
import 'package:cardly/main.dart';
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

  bool obscurePasswordField = true;

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
      obscurePasswordField = !obscurePasswordField;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (_, constraints) {
                return Container(
                  height: 300,
                  color: BrandColor.primaryColorShade2,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://github.com/black-coda/image-host/blob/main/image-removebg-preview.png?raw=true",
                    placeholder: (context, url) => const SizedBox(
                      height: 50,
                      width: 50,
                      child: LinearProgressIndicator(
                        color: BrandColor.primaryColor,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
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
                        const SizedBox(height: 50),
                        DynamicInputWidget(
                          isNonPasswordField: !isNonPasswordField,
                          controller: emailController,
                          obscureText: false,
                          focusNode: emailFocusNode,
                          labelText: "Enter Email",
                          textInputAction: TextInputAction.next,
                          validator: authValidators.emailValidator,
                        ),
                        const SizedBox(height: 18),
                        // Password input field
                        DynamicInputWidget(
                          isNonPasswordField: isNonPasswordField,
                          controller: passwordController,
                          obscureText: obscurePasswordField,
                          focusNode: passwordFocusNode,
                          labelText: "Enter Password",
                          textInputAction: TextInputAction.done,
                          toggleObscureText: toggleObscureText,
                        ),
                        const SizedBox(height: 32),
                        // Login button
                        CustomButton(
                          text: "Login",
                          onPressed: () async {
                            final router = ref.watch(goRouterConfigProvider);
                            if (_formKey.currentState!.validate()) {
                              final email = emailController.text;
                              final password = passwordController.text;
                              final userModel =
                                  UserModel(email: email, password: password);
                              await ref
                                  .read(authProvider.notifier)
                                  .login(userModel, context);
                            }
                          },
                        ),
                        const SizedBox(height: 24),
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
