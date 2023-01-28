import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';

import '../../utils/snackbar_builder.dart';
import 'auth_section_builder.dart';
import 'authentication_screen.dart';

class Login extends StatefulWidget {
  final Function(AuthState state) func;

  const Login({super.key, required this.func});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  bool _rememberMe = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget get rememberMeCheckbox {
    return InkWell(
      onTap: () {
        setState(() {
          _rememberMe = !_rememberMe;
        });
      },
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity(horizontal: -4),
                value: _rememberMe,
                onChanged: (val) => setState(() {
                      _rememberMe = val!;
                    })),
            SizedBox(width: 6),
            Text('Remember me?')
          ]),
    );
  }

  Row get forgotPasswordSection {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero),
            onPressed: () {
              widget.func(AuthState.changePassword);
            },
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) {
        return Form(
            key: _formKey,
            child: AuthSectionBuilder()
                .withInput(
                  false,
                  InputFieldType.email,
                  emailController,
                  context,
                  "Email",
                  "Enter your email",
                )
                .withInput(false, InputFieldType.password, passwordController,
                    context, "Password", "Enter your password")
                .withWidget(rememberMeCheckbox)
                .withButton(_isLoading, "LOGIN", () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  final email = emailController.text;
                  final pass = passwordController.text;

                  setState(() {
                    _isLoading = true;
                  });

                  final result = await auth.signIn("username", "password");

                  setState(() {
                    _isLoading = false;
                  });

                  if (!result) {
                    AppSnackBar.show(context,
                        AppSnackBarBuilder().withText("Login failed!"));
                  }

                  // TODO handle backend login
                  print("[API] Login ($email, $pass)");
                })
                .withWidget(forgotPasswordSection)
                .withSubsection(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Need an account?'),
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size.zero),
                        onPressed: () {
                          widget.func(AuthState.register);
                        },
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ))
                  ],
                ))
                .build());
      },
    );
  }
}
