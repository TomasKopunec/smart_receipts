import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/utils/snackbar_builder.dart';
import 'package:smart_receipts/widgets/dialogs/confirm_dialog.dart';
import 'package:smart_receipts/widgets/dialogs/loading_button.dart';

import '../../helpers/currency_helper.dart';
import '../../providers/settings/settings_provider.dart';

class DialogHelper {
  static void showConfirmDialog({
    required BuildContext context,
    String title = "Confirmation",
    String subtitle = "",
    IconData icon = Icons.check,
    List<Widget> buttons = const [],
    Color? color,
    TextEditingController? controller,
    Key? key,
    bool isForm = false,
  }) {
    final dialog = ConfirmDialog(
      title: title,
      subtitle: subtitle,
      icon: icon,
      buttons: buttons,
      color: color ?? Theme.of(context).primaryColor,
      input: controller,
    );

    showDialog(
        context: context,
        builder: (context) => isForm ? Form(key: key!, child: dialog) : dialog);
  }

  static void showChangedPasswordSuccess(
      BuildContext context, bool isLoggedIn) {
    showConfirmDialog(
        context: context,
        title: "Success",
        subtitle: isLoggedIn
            ? "Password has been changed successfully. Your account has been updated."
            : "Password has been changed successfully. You can now log in with your new password.",
        icon: Icons.check_circle,
        buttons: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('OK')),
        ]);
  }

  static void confirmAccountDeletion(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    const redColor = Color.fromRGBO(216, 90, 78, 1);
    showConfirmDialog(
        context: context,
        title: 'Delete Account',
        subtitle:
            'Are you sure you want to delete your account? All your receipts and returns will be lost!',
        icon: Icons.delete,
        color: redColor,
        controller: controller,
        isForm: true,
        key: _formKey,
        buttons: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            child: const Text('No'),
          ),
          Consumer<UserProvider>(
              builder: (ctx, users, child) => LoadingButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final result = await users.deleteAccount(
                        token: Provider.of<AuthProvider>(context, listen: false)
                            .token!
                            .accessToken,
                        email: users.user!.email,
                        password: controller.text,
                      );

                      if (result.status) {
                        Provider.of<AuthProvider>(context, listen: false)
                            .setToken(null);
                        users.clearUser();
                        Navigator.pop(context, false);
                      }

                      AppSnackBar.show(context,
                          AppSnackBarBuilder().withText(result.message!));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: redColor),
                    child: const Text('Yes'),
                  ))
        ]);
  }

  static void showDeleteReceiptDialog(BuildContext context) {
    showConfirmDialog(
        context: context,
        title: 'Delete Receipt',
        subtitle: 'Are you sure you want to remove this receipt?',
        icon: Icons.delete,
        buttons: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'))
        ]);
  }

  static void showReceivedNewReceipt(BuildContext context, Receipt receipt) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: SizeHelper.getScreenHeight(context) * 0.6,
            width: double.maxFinite,
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Consumer<SettingsProvider>(
              builder: (ctx, settings, _) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt,
                        color: Theme.of(context).primaryColor,
                        size: SizeHelper.getScreenHeight(context) * 0.2,
                      ),
                      AutoSizeText(
                        "Received New Receipt!",
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).indicatorColor,
                            fontSize:
                                SizeHelper.getScreenHeight(context) * 0.04),
                      ),
                      Text(
                        receipt.getField(ReceiptField.retailerName),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: SizeHelper.getFontSize(context,
                                    size: FontSize.largest)),
                      ),
                      Text(
                        CurrencyHelper.getFormatted(
                            receipt.getField(ReceiptField.price),
                            settings.currency),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: SizeHelper.getFontSize(context,
                                    size: FontSize.larger)),
                      ),
                      Text(
                        DateFormat(settings.dateTimeFormat.format).format(
                            receipt.getField(ReceiptField.purchaseDateTime)),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: SizeHelper.getFontSize(context,
                                    size: FontSize.large)),
                      ),
                      Text(
                        "Thank you for your purchase!",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: SizeHelper.getFontSize(context,
                                    size: FontSize.largest)),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                icon: const Icon(Icons.check_circle),
                                label: const Text('OK')),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}
