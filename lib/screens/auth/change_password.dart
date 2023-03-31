import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/widgets/dialogs/dialog_helper.dart';

import '../../utils/snackbar_builder.dart';
import 'auth_section_builder.dart';
import 'authentication_screen.dart';

class ChangePassword extends StatefulWidget {
  final Function(AuthState state) func;
  final bool isLoggedIn;

  const ChangePassword(
      {super.key, required this.func, this.isLoggedIn = false});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController oldPasswordController =
      TextEditingController(text: "");
  final TextEditingController newPasswordController =
      TextEditingController(text: "");
  final TextEditingController newPasswordRepeatController =
      TextEditingController(text: " ");

  @override
  void dispose() {
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (ctx, users, _) {
        return Form(
            key: _formKey,
            child: AuthSectionBuilder()
                .withWidget(Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: SizeHelper.getFontSize(context,
                                size: FontSize.regularSmall)),
                        "Enter the details associated with your account along with your old and new password."),
                  ),
                ))
                .withInput(
                  false,
                  InputFieldType.email,
                  emailController,
                  context,
                  "Email",
                  "Enter your email",
                )
                .withInput(
                  false,
                  InputFieldType.password,
                  oldPasswordController,
                  context,
                  "Old Password",
                  "Enter your old password",
                )
                .withInput(
                  false,
                  InputFieldType.password,
                  newPasswordController,
                  context,
                  "New Password",
                  "Enter your new password",
                )
                .withInput(
                  false,
                  InputFieldType.repPassword,
                  newPasswordRepeatController,
                  context,
                  "Confirm New Password",
                  "Enter your new password again",
                )
                .withButton(_isLoading, "CHANGE PASSWORD",
                    icon: _isLoading ? null : const Icon(Icons.restart_alt),
                    () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              setState(() {
                _isLoading = true;
              });

              final result = await users.changePassword(
                email: emailController.text,
                oldPassword: oldPasswordController.text,
                newPassword: newPasswordController.text,
                newPasswordRepeat: newPasswordRepeatController.text,
              );

              setState(() {
                _isLoading = false;
              });

              if (mounted) {
                if (result.status) {
                  DialogHelper.showChangedPasswordSuccess(
                      context, widget.isLoggedIn);
                } else {
                  AppSnackBar.show(
                      context,
                      AppSnackBarBuilder().withText(
                          "Failed to change password. ${result.message}"));
                }
              }
            }).build());
      },
    );
  }
}
