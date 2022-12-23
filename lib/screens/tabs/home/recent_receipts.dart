import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/currency_helper.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/providers/screen_provider.dart.dart';
import 'package:smart_receipts/providers/settings_provider.dart';
import 'package:smart_receipts/widgets/section.dart';

import '../../../helpers/size_helper.dart';
import '../../show_receipt_screen.dart';

class RecentReceipts extends StatelessWidget {
  const RecentReceipts({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
        title: 'Recent Receipts',
        titleAction: Ink(
          child: InkWell(
            onTap: () => Provider.of<ScreenProvider>(context, listen: false)
                .setSelectedIndex(1),
            child: Padding(
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
        body: Consumer<ReceiptsProvider>(
          builder: (_, provider, __) {
            return Column(
              children: getMostRecentReceipts(context),
            );
          },
        ));
  }

  List<Widget> getMostRecentReceipts(context) {
    List<Widget> widgets = [];

    Provider.of<ReceiptsProvider>(context, listen: false)
        .getMostRecent(2)
        .forEach((receipt) {
      widgets.add(Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
        child: Consumer<SettingsProvider>(
          builder: (ctx, settings, _) {
            return ListTile(
                onTap: () {
                  _showReceipt(context, receipt.getField(ReceiptField.id));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(
                    '${receipt.getField(ReceiptField.retailer_name)} (${receipt.getProductsCount()} products)'),
                subtitle: Text(DateFormat(settings.dateTimeFormat.format)
                    .format(receipt.getField(ReceiptField.purchase_date_time))),
                trailing: Text(
                  CurrencyHelper.getFormatted(
                      receipt.getField(ReceiptField.price), settings.currency),
                  style: Theme.of(context).textTheme.titleMedium,
                ));
          },
        ),
      ));
      widgets.add(const SizedBox(height: 4));
    });

    return widgets;
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
