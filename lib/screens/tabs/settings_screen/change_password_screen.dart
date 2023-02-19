import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/auth/change_password.dart';
import 'package:smart_receipts/screens/returnable_screen.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReturnableScreen(
      title: "Change Password",
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ChangePassword(func: ((state) {}), isLoggedIn: true)),
    );
  }
}
