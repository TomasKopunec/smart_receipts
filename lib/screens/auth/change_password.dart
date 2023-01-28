import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';

import '../../utils/snackbar_builder.dart';
import 'auth_section_builder.dart';
import 'authentication_screen.dart';

class ChangePassword extends StatefulWidget {
  final Function(AuthState state) func;

  const ChangePassword({super.key, required this.func});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
                .withWidget(Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: SizeHelper.getFontSize(context,
                                size: FontSize.regularSmall)),
                        "Enter the email associated with your account and we'll send an email with instructions to reset your password."),
                  ),
                ))
                .withButton(_isLoading, "SEND INSTRUCTIONS", () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              final email = emailController.text;

              setState(() {
                _isLoading = true;
              });

              final result = await auth.changePassword("email");

              setState(() {
                _isLoading = false;
              });

              AppSnackBar.show(
                  context,
                  AppSnackBarBuilder()
                      .withText(result
                          ? "Instructions have been successfully sent to the email."
                          : "Error occured when changing password.")
                      .withDuration(const Duration(seconds: 5)));

              // TODO handle backend change password
              print("[API] Change Password ($email)");
            }).build());
      },
    );
  }
}
