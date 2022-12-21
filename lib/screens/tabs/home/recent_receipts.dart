import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/providers/screen_provider.dart.dart';
import 'package:smart_receipts/widgets/section.dart';

import '../../../helpers/size_helper.dart';
import '../../show_receipt_screen.dart';

class RecentReceipts extends StatelessWidget {
  const RecentReceipts({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
        title: 'Recent Receipts',
        titleAction: TextButton(
            onPressed: () {
              Provider.of<ScreenProvider>(context, listen: false)
                  .setSelectedIndex(1);
            },
            child: Text('View All')),
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
        elevation: 6,
        child: ListTile(
            onTap: () {
              _showReceipt(context, receipt.getField(ReceiptField.id));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            tileColor: Colors.white,
            textColor: Colors.black,
            title: Text(
                '${receipt.getField(ReceiptField.retailer_name)} (${receipt.getProductsCount()} products)'),
            subtitle: Text(DateFormat.yMMMMd()
                .format(receipt.getField(ReceiptField.purchase_date_time))),
            trailing: Text(
              '£${receipt.getField(ReceiptField.price).toStringAsFixed(2)}',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeHelper.getFontSize(context,
                      size: FontSize.regularLarge)),
            )),
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
