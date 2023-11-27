import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/config/theme/color.dart';
import 'package:cardly/features/authentication/domain/models/user.dart';
import 'package:cardly/features/authentication/presentation/controllers/controllers.dart';
import 'package:cardly/utils/forms/dynamic_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_button.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final isNonPasswordField = false;
  static const String confirmPasswordErrMsg = "Passwords don't match 🤦.";

  final AuthValidators authValidators = AuthValidators();
  String? confirmPasswordValidator(String? val1) {
    final String password1 = val1 as String;
    final String password2 = passwordController.text;

    if (password1.isEmpty ||
        password2.isEmpty ||
        password1.length != password2.length) return confirmPasswordErrMsg;

    //  If two passwords do not match then send an error message

    if (password1 != password2) return confirmPasswordErrMsg;

    return null;
  }

  bool obscurePasswordField = true;

  // Controllers
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  // Focus nodes
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    // Dispose of controllers
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    // Dispose of focus nodes
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }

  /// Toggles the visibility of the password text.
  void toggleObscureText() {
    setState(() {
      obscurePasswordField = !obscurePasswordField;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar.medium(
            title: Text("Registration Screen"),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome message
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        color: BrandColor.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Subtitle
                    const Text(
                      "Please use correct information here",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: BrandColor.grey,
                      ),
                    ),
                    const SizedBox(height: 56),
                    //* Email input field
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
                    DynamicInputWidget(
                      isNonPasswordField: isNonPasswordField,
                      controller: passwordController,
                      obscureText: obscurePasswordField,
                      focusNode: passwordFocusNode,
                      labelText: "Enter Password",
                      textInputAction: TextInputAction.next,
                      toggleObscureText: toggleObscureText,
                      validator: authValidators.passwordWordValidator,
                    ),
                    const SizedBox(height: 18),
                    DynamicInputWidget(
                      isNonPasswordField: isNonPasswordField,
                      controller: confirmPasswordController,
                      obscureText: obscurePasswordField,
                      focusNode: confirmPasswordFocusNode,
                      labelText: "Confirm Password",
                      textInputAction: TextInputAction.done,
                      toggleObscureText: toggleObscureText,
                      validator: confirmPasswordValidator,
                    ),
                    const SizedBox(height: 32),
                    // Login button
                    CustomButton(
                      textColor: BrandColor.white,
                      text: "Register",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final email = emailController.text;
                          final password = passwordController.text;
                          final password2 = confirmPasswordController.text;
                          final userModel = UserModel(
                              email: email,
                              password: password,
                              password2: password2,
                              firstName: "Solom",
                              lastName: "Davuy");

                          await ref
                              .read(authProvider.notifier)
                              .register(userModel, context);
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    TextButton(
                      onPressed: () async {
                        context.pushNamed("login");
                      },
                      child: const Text("Login"),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
