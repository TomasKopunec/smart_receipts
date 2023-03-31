import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/currency_helper.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/screen_provider.dart.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/widgets/section.dart';
import 'package:smart_receipts/widgets/shimmer_widget.dart';

import '../../../helpers/size_helper.dart';
import '../../show_receipt_screen.dart';

class RecentReceipts extends StatelessWidget {
  final bool isLoading;

  const RecentReceipts({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptsProvider>(
      builder: (ctx, receipts, _) => Section(
          title: 'Recent Receipts',
          titleAction: receipts.receiptSize == 0
              ? Container()
              : Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        Provider.of<ScreenProvider>(context, listen: false)
                            .setSelectedIndex(1),
                    splashColor: Theme.of(context).primaryColor,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        'View All',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: SizeHelper.getFontSize(context,
                                size: FontSize.regularLarge)),
                      ),
                    ),
                  ),
                ),
          body: Column(
            children: getMostRecentReceipts(context, receipts),
          )),
    );
  }

  List<Widget> getMostRecentReceipts(context, ReceiptsProvider receipts) {
    if (isLoading) {
      return [
        getBlankReceiptCard(),
        getBlankReceiptCard(),
      ];
    }

    if (receipts.receiptSize == 0) {
      return [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('No receipts have been received yet.',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: SizeHelper.getFontSize(context,
                          size: FontSize.regularLarge))),
              const SizedBox(
                height: 8,
              ),
              Text(
                  'Once you make your first purchase, the most recent receipts will show up here.',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: SizeHelper.getFontSize(context,
                          size: FontSize.regularSmall))),
            ],
          ),
        )
      ];
    }

    List<Widget> widgets = [];

    receipts.getMostRecentN(2).forEach((receipt) {
      widgets.add(getReceiptCard(context, receipt));
      widgets.add(const SizedBox(height: 4));
    });

    return widgets;
  }

  Widget getReceiptCard(BuildContext context, Receipt receipt) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      child: Consumer<SettingsProvider>(
        builder: (ctx, settings, _) {
          return ListTile(
              onTap: () {
                _showReceipt(context, receipt.getField(ReceiptField.receiptId));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(
                '${receipt.getField(ReceiptField.retailerName)} (${receipt.getProductsCount()} products)',
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              ),
              subtitle: Text(
                DateFormat(settings.dateTimeFormat.format)
                    .format(receipt.getField(ReceiptField.purchaseDateTime)),
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              ),
              trailing: Text(
                CurrencyHelper.getFormatted(
                    price: receipt.getField(ReceiptField.price),
                    originCurrency: receipt.currency,
                    targetCurrency: settings.currency),
                style: Theme.of(context).textTheme.titleMedium,
              ));
        },
      ),
    );
  }

  Widget getBlankReceiptCard() {
    return ShimmerWidget(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
        child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: const Text(""),
            subtitle: const Text(""),
            trailing: const Text("")),
      ),
    );
  }

  void _showReceipt(context, id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ShowReceiptScreen(),
          settings: RouteSettings(arguments: id),
        ));
  }
}
