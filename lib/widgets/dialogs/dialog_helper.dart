import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/widgets/dialogs/confirm_dialog.dart';

import '../../helpers/currency_helper.dart';
import '../../providers/settings/settings_provider.dart';

class DialogHelper {
  static void showDeleteReceiptDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
              title: 'Delete Receipt',
              subtitle: 'Are you sure you want to remove this receipt?',
              icon: Icons.delete,
              buttons: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('No')),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes')),
              ],
            ));
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
                                icon: Icon(Icons.check_circle),
                                label: Text('OK')),
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
