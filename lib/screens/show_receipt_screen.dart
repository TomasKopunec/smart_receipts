import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/screens/returnable_screen.dart';
import 'package:smart_receipts/widgets/receipt_status_label.dart';

import '../helpers/currency_helper.dart';
import '../models/receipt/receipt.dart';

class ShowReceiptScreen extends StatelessWidget {
  late Receipt receipt;
  late SettingsProvider settings;

  ShowReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    settings = Provider.of<SettingsProvider>(context, listen: true);
    final id = ModalRoute.of(context)!.settings.arguments as int;

    // receipt = Receipt(
    //     id: 1,
    //     auto_delete_date_time: DateTime.now(),
    //     retailer_receipt_id: 2,
    //     retailer_id: 3,
    //     retailer_name: "Zara",
    //     customer_id: 4,
    //     purchase_date_time: DateTime.now(),
    //     purchase_location: "Southampton",
    //     status: ReceiptStatus.active,
    //     expiration: DateTime.now().add(const Duration(days: 365)),
    //     price: 59.99,
    //     currency: "GBP",
    //     paymentMethod: "Card",
    //     cardNumber: "1234 1234 1234 1234",
    //     products: [
    //       Product(
    //           id: 1,
    //           name: "T-Shirt",
    //           price: 19.99,
    //           sku: "1234-5678",
    //           category: "Men T-Shirts"),
    //       Product(
    //           id: 2,
    //           name: "Socks",
    //           price: 9.99,
    //           sku: "1234-9999",
    //           category: "Men Accessories"),
    //       Product(
    //           id: 3,
    //           name: "Jeans",
    //           price: 39.99,
    //           sku: "9999-5678",
    //           category: "Men Pants"),
    //       Product(
    //           id: 4,
    //           name: "Jeans",
    //           price: 39.99,
    //           sku: "9999-5678",
    //           category: "Men Pants"),
    //       Product(
    //           id: 5,
    //           name: "Jacket",
    //           price: 109.99,
    //           sku: "1BA4-5AS8",
    //           category: "Men Clothing"),
    //     ]);

    receipt = Provider.of<ReceiptsProvider>(context, listen: false)
        .getReceiptById(id);

    return ReturnableScreen(
        receiptId: receipt.id,
        title: receipt.retailer_name,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              getTitle(context),
              getProducts(context),
              getSums(context),
              getAdditional(context),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Thank you for shopping with ${receipt.retailer_name}!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: SizeHelper.getFontSize(context,
                              size: FontSize.largest)),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text("Return Products"),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget getCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget getTitle(BuildContext context) {
    return getSection(context, receipt.retailer_name, [
      getSectionEntry("Location: ", receipt.purchase_location),

      // Date time
      getSectionEntry(
          "Date: ",
          DateFormat(settings.dateTimeFormat.format)
              .format(receipt.getField(ReceiptField.purchase_date_time))),

      getSectionEntry(
          "Number of products: ", receipt.getProductsCount().toString()),
      getSectionEntry(
          "Total Price: ",
          CurrencyHelper.getFormatted(
              receipt.getField(ReceiptField.price), settings.currency)),
    ]);
  }

  Widget getProducts(BuildContext context) {
    List<Widget> productEntries = [];

    // For each product, group by SKU
    Map<String, int> skuGroup = HashMap();
    for (var e in receipt.products) {
      skuGroup.update(e.sku, (value) => ++value, ifAbsent: () => 1);
    }

    final Set keys = HashSet();
    for (var p in receipt.products) {
      final int count = skuGroup[p.sku]!;
      if (keys.contains(p.sku)) {
        continue;
      }

      keys.add(p.sku);
      productEntries.add(getSectionEntry("${p.name} ($count x ${p.price})",
          CurrencyHelper.getFormatted(p.price * count, settings.currency)));
    }

    return getSection(context, "Products", productEntries);
  }

  Widget getSums(BuildContext context) {
    List<Widget> widgets = [];

    // Total
    widgets.add(getSectionEntry("Total Paid: ",
        CurrencyHelper.getFormatted(receipt.price, settings.currency)));

    // Payment Method
    widgets.add(getSectionEntry("Payment Method: ", receipt.paymentMethod));

    // Card number
    if (receipt.paymentMethod.toLowerCase() == "card") {
      final String cardNumber = receipt.cardNumber!;
      widgets.add(getSectionEntry("Card Number: ",
          "•••• •••• •••• ${cardNumber.substring(cardNumber.length - 5)}"));
    }

    return getSection(context, "Payment", widgets);
  }

  Widget getAdditional(BuildContext context) {
    return getSection(context, "Additional details", [
      getSectionEntry(
          "Expiration: ",
          DateFormat(settings.dateTimeFormat.format)
              .format(receipt.getField(ReceiptField.purchase_date_time))),
      getSectionEntryStatus(
          "Receipt Status: ", ReceiptStatusLabel(status: receipt.status)),
      getSectionEntry("Receipt ID: ", receipt.id.toString()),
    ]);
  }

  Widget getSection(BuildContext context, String title, List<Widget> widgets) {
    return getCard(Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        ...widgets
      ],
    ));
  }

  Widget getSectionEntry(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left),
          Text(right),
        ],
      ),
    );
  }

  Widget getSectionEntryStatus(String left, Widget right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left),
          right,
        ],
      ),
    );
  }
}
