import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import '../../helpers/requests/auth_request_helper.dart';
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
  void initState() {
    emailController.text = "email@email.com";
    passwordController.text = "123456789";
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                  handleLogin(auth);
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

  void handleLogin(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text;
    final password = passwordController.text;

    setState(() {
      _isLoading = true;
    });

    // Wait for response
    AuthResponseDTO? result;
    try {
      result = await auth.login(email, password);
    } catch (e) {
      result = AuthResponseDTO(status: false, message: e.toString());
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      AppSnackBar.show(context, AppSnackBarBuilder().withText(result.message));
    }

    if (result.status) {
      auth.setToken(result.token!);
    }
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
            const SizedBox(width: 6),
            const Text('Remember me?')
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
}
