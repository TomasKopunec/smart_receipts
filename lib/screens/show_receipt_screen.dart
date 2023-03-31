import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
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

class ShowReceiptScreen extends StatefulWidget {
  const ShowReceiptScreen({super.key});

  @override
  State<ShowReceiptScreen> createState() => _ShowReceiptScreenState();
}

class _ShowReceiptScreenState extends State<ShowReceiptScreen> {
  bool _isFavourite = false;
  late final ReceiptsProvider receipts;
  late final SettingsProvider settings;
  late final Receipt receipt;
  String? id;

  @override
  void initState() {
    super.initState();

    settings = Provider.of<SettingsProvider>(context, listen: false);
    receipts = Provider.of<ReceiptsProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    id = ModalRoute.of(context)!.settings.arguments as String;
    receipt = receipts.getReceiptById(id!);
    _isFavourite = receipts.isFavorite(id!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ReturnableScreen(
        title: receipt.retailerName,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isFavourite = receipts.flipFavorite(receipt.receiptId);
                });
              },
              icon: Icon(_isFavourite ? Icons.star : Icons.star_border)),
        ],
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              getTitle(context),
              getProducts(context),
              getSums(context),
              getAdditional(context),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Thank you for shopping with ${receipt.retailerName}!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: SizeHelper.getFontSize(context,
                              size: FontSize.largest)),
                    ),
                    if (isReturnable) returnsSection
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget get returnsSection {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            "If you wish to return any of the items, please press the return button below.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: SizeHelper.getFontSize(
                  context,
                  size: FontSize.large,
                )),
          ),
          const SizedBox(height: 10),
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
    );
  }

  bool get isReturnable {
    return receipt.products.where((e) => !e.returns.returned).isNotEmpty;
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
            price: receipt.getField(ReceiptField.price),
            originCurrency: receipt.currency,
            targetCurrency: settings.currency,
          )),
    ]);
  }

  Widget getProducts(BuildContext context) {
    List<Widget> productEntries = [];

    // For each product, group by ProductDTO
    Set<ProductDto> set = HashSet();
    for (var p in receipt.products) {
      final dto = ProductDto(product: p, count: 0, returnedCount: 0);
      if (set.contains(dto)) {
        final ProductDto loaded =
            set.firstWhere((dto) => dto.product.sku == p.sku);
        loaded.count++;
        if (p.returns.returned) {
          loaded.returnedCount++;
        }
        set.removeWhere((dto) => dto.product.sku == p.sku);
        set.add(loaded);
      } else {
        dto.count++;
        if (p.returns.returned) {
          dto.returnedCount++;
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

      String returned = "${p.name} ($count x ${CurrencyHelper.getFormatted(
        price: p.price * count,
        originCurrency: receipt.currency,
        targetCurrency: settings.currency,
        includeCurrency: false,
      )})";

      if (dto.returnedCount > 0) {
        returned =
            "$returned  #Returned ${dto.returnedCount == dto.count ? 'All' : '${dto.returnedCount}'}";
      }

      productEntries.add(getSectionEntry(
        returned,
        CurrencyHelper.getFormatted(
          price: p.price * count,
          originCurrency: receipt.currency,
          targetCurrency: settings.currency,
        ),
      ));
    }

    return getSection(context, "Products", productEntries);
  }

  Widget getSums(BuildContext context) {
    List<Widget> widgets = [];

    // Total
    widgets.add(getSectionEntry(
        "Total Paid: ",
        CurrencyHelper.getFormatted(
          price: receipt.price,
          originCurrency: receipt.currency,
          targetCurrency: settings.currency,
        )));

    // Payment Method
    widgets.add(getSectionEntry("Payment Method: ", receipt.paymentMethod));

    // Card number
    if (receipt.paymentMethod.toLowerCase() == "card") {
      final String cardNumber = receipt.cardNumber!;
      widgets.add(getSectionEntry("Card Number: ",
          "•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}"));
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
      getReceiptId(receipt.receiptId),
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
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(left,
              style: TextStyle(
                  fontSize: SizeHelper.getFontSize(
                context,
              ))),
          AutoSizeText(
            right,
            maxLines: 1,
            style: TextStyle(
                overflow: TextOverflow.fade,
                fontSize: SizeHelper.getFontSize(
                  context,
                )),
          ),
        ],
      ),
    );
  }

  Widget getReceiptId(String id) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Receipt ID:",
              style: TextStyle(
                  fontSize: SizeHelper.getFontSize(
                context,
              ))),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              id,
              style: TextStyle(
                  overflow: TextOverflow.fade,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeHelper.getFontSize(
                    context,
                  )),
            ),
          ),
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
          Text(
            left,
            style: TextStyle(fontSize: SizeHelper.getFontSize(context)),
          ),
          right,
        ],
      ),
    );
  }
}

class ProductDto {
  final Product product;
  int count = 0;
  int returnedCount = 0;

  ProductDto({
    required this.product,
    this.count = 0,
    this.returnedCount = 0,
  });

  @override
  int get hashCode {
    return product.sku.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return (other is ProductDto) && (other.product.sku == product.sku);
  }
}
