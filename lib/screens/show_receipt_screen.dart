import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/screens/return_screen/return_from_receipt_screen.dart';
import 'package:smart_receipts/screens/returnable_screen.dart';
import 'package:smart_receipts/widgets/receipt_status_label.dart';

import '../helpers/currency_helper.dart';
import '../models/product/product.dart';
import '../models/receipt/receipt.dart';
import '../widgets/dialogs/dialog_helper.dart';

class ShowReceiptScreen extends StatelessWidget {
  late Receipt receipt;
  late SettingsProvider settings;

  ShowReceiptScreen({super.key});

  void _delete(BuildContext context) async {
    DialogHelper.showDeleteReceiptDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    settings = Provider.of<SettingsProvider>(context, listen: false);
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final provider = Provider.of<ReceiptsProvider>(context, listen: false);
    receipt = provider.getReceiptById(id);

    return ReturnableScreen(
        receiptId: receipt.receiptId,
        title: receipt.retailerName,
        actions: [
          IconButton(
              onPressed: () {
                provider.flipFavorite(receipt.receiptId, true);
              },
              icon: Icon(provider.isFavorite(receipt.receiptId)
                  ? Icons.star
                  : Icons.star_border)),
          IconButton(
              onPressed: () => _delete(context),
              icon: const Icon(Icons.delete)),
        ],
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
                      "Thank you for shopping with ${receipt.retailerName}!",
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
                            onPressed: () {
                              _returnItems(context);
                            },
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

  void _returnItems(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReturnFromReceiptScreen(
                  receipt: receipt,
                )));
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
    return getSection(context, receipt.retailerName, [
      getSectionEntry("Location: ", receipt.purchaseLocation),

      // Date time
      getSectionEntry(
          "Date: ",
          DateFormat(settings.dateTimeFormat.format)
              .format(receipt.getField(ReceiptField.purchaseDateTime))),

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

    // For each product, group by ProductDTO
    Set<ProductDto> set = HashSet();
    for (var p in receipt.products) {
      final dto = ProductDto(product: p, count: 0, returned_count: 0);
      if (set.contains(dto)) {
        final ProductDto loaded =
            set.firstWhere((dto) => dto.product.sku == p.sku);
        loaded.count++;
        if (p.returns.returned) {
          loaded.returned_count++;
        }
        set.removeWhere((dto) => dto.product.sku == p.sku);
        set.add(loaded);
      } else {
        dto.count++;
        if (p.returns.returned) {
          dto.returned_count++;
        }
        set.add(dto);
      }
    }

    final Set keys = HashSet();
    for (var p in receipt.products) {
      final dto = set.firstWhere((dto) => dto.product.sku == p.sku);
      final int count = dto.count;
      if (keys.contains(p.sku)) {
        continue;
      }

      keys.add(p.sku);

      String returned = "${p.name} ($count x ${p.price})";

      if (dto.returned_count > 0) {
        returned =
            "$returned  #Returned ${dto.returned_count == dto.count ? 'All' : '${dto.returned_count}}'}";
      }

      productEntries.add(getSectionEntry(returned,
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
              .format(receipt.getField(ReceiptField.purchaseDateTime))),
      getSectionEntryStatus(
          "Receipt Status: ", ReceiptStatusLabel(status: receipt.status)),
      getSectionEntry("Receipt ID: ", receipt.receiptId.toString()),
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

class ProductDto {
  final Product product;
  int count = 0;
  int returned_count = 0;

  ProductDto({
    required this.product,
    this.count = 0,
    this.returned_count = 0,
  });

  @override
  int get hashCode {
    return product.sku.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return (other is ProductDto) && (other.product.sku == other.product.sku);
  }
}
