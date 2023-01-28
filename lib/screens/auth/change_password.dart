import 'package:flutter/material.dart';

import 'auth_section_builder.dart';
import 'authentication_screen.dart';

class ChangePassword extends StatefulWidget {
  final Function(AuthState state) func;

  const ChangePassword({super.key, required this.func});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: AuthSectionBuilder()
            .withInput(
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
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.7)),
                    "Enter the email associated with your account and we'll send an email with instructions to reset your password."),
              ),
            ))
            .withButton("SEND INSTRUCTIONS", () {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          final email = emailController.text;

          // TODO handle backend change password
          print("[API] Change Password ($email)");
        }).build());
  }
}
