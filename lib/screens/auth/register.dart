import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/requests/auth_request_helper.dart';
import 'package:smart_receipts/helpers/requests/request_helper.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/screens/auth/auth_section_builder.dart';
import 'package:smart_receipts/screens/auth/authentication_screen.dart';
import 'package:smart_receipts/utils/snackbar_builder.dart';

class Register extends StatefulWidget {
  final Function(AuthState state) func;

  const Register({super.key, required this.func});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  @override
  void initState() {
    emailController.text = "email@email.com";
    passwordController.text = "123456789";
    repeatPasswordController.text = "123456789";

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, child) {
        return Form(
            key: _formKey,
            child: AuthSectionBuilder()
                .withInput(
                  true,
                  InputFieldType.email,
                  emailController,
                  context,
                  "Email",
                  "Enter your email",
                )
                .withInput(true, InputFieldType.password, passwordController,
                    context, "Password", "Enter your password")
                .withInput(
                    true,
                    InputFieldType.repPassword,
                    repeatPasswordController,
                    context,
                    "Confirm Password",
                    "Enter your password again")
                .withButton(_isLoading, "SIGN UP", () async {
                  handleRegister(auth);
                })
                .withSubsection(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a user?'),
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size.zero),
                        onPressed: () {
                          widget.func(AuthState.login);
                        },
                        child: const Text(
                          'LOGIN',
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

  void handleRegister(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text;
    final password = passwordController.text;

    if (password != repeatPasswordController.text) {
      AppSnackBar.show(
          context,
          AppSnackBarBuilder()
              .withText("Passwords do not match!")
              .withDuration(const Duration(seconds: 4)));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Wait for response
    bool isException = false;
    AuthResponseDTO? result;
    try {
      result = await auth.register(email, password);
    } catch (e) {
      isException = true;
      result = AuthResponseDTO(status: false, message: e.toString());
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (isException) {
        RequestHelper.showNetworkErrorDialog(context,
            err: result.message, title: "Network Exception");
      } else {
        AppSnackBar.show(
            context, AppSnackBarBuilder().withText(result.message));
      }
    }

    if (result.status) {
      auth.setToken(result.token!);
    }
  }
}
