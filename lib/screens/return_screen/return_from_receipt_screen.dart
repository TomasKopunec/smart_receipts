import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/currency_helper.dart';
import 'package:smart_receipts/helpers/qr_code_helper.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/product/product.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/screens/return_screen/return_selection.dart';
import 'package:smart_receipts/screens/returnable_screen.dart';

import '../../models/receipt/receipt.dart';

class ReturnFromReceiptScreen extends StatefulWidget {
  final Receipt receipt;

  ReturnFromReceiptScreen({super.key, required this.receipt});

  @override
  State<ReturnFromReceiptScreen> createState() =>
      _ReturnFromReceiptScreenState();
}

class _ReturnFromReceiptScreenState extends State<ReturnFromReceiptScreen> {
  final Set<Selection> _pairs = {};

  bool _showingQRCode = false;

  @override
  Widget build(BuildContext context) {
    return ReturnableScreen(
        receiptId: widget.receipt.receiptId,
        title: "Return Items",
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              getMain(context),
              getSummary(context),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  if (_showingQRCode)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "Present the QR code at the nearest ",
                            children: [
                              TextSpan(
                                  text: widget.receipt.retailerName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: " store",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontWeight: FontWeight.w300)),
                            ],
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.w300)),
                      ),
                    ),
                  Consumer<UserProvider>(
                    builder: (ctx, user, _) => AnimatedContainer(
                        duration: const Duration(milliseconds: 1800),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: _showingQRCode
                            ? SizeHelper.getScreenWidth(context)
                            : 0,
                        child: getQrCodeView(user.user!.email)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showingQRCode = !_showingQRCode;
                              });
                            },
                            icon: const Icon(Icons.qr_code),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(_showingQRCode
                                  ? "Modify Returned Products "
                                  : "Generate QR Code"),
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

  Widget getQrCodeView(String email) {
    return _showingQRCode
        ? Card(
            elevation: 5,
            child: Container(
              color: Colors.white,
              child: Padding(
                  padding:
                      EdgeInsets.all(SizeHelper.getScreenWidth(context) * 0.05),
                  child: QrCodeHelper.getReturnQrCodeWidget(
                      context, email, getPairsMap(),
                      size: SizeHelper.getScreenWidth(context))),
            ),
          )
        : Container();
  }

  Widget getSection(BuildContext context, String title, List<Widget> widgets,
      {String? subtitle}) {
    return getCard(Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (subtitle != null)
          Column(
            children: [
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleMedium,
              )
            ],
          ),
        const SizedBox(height: 4),
        ...widgets
      ],
    ));
  }

  Widget getCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget getMain(BuildContext context) {
    List<Widget> productEntries = [];

    // For each product, group by SKU
    Map<String, int> skuGroup = HashMap();
    for (var e in widget.receipt.products) {
      skuGroup.update(e.sku, (value) => ++value, ifAbsent: () => 1);
    }

    final Set skus = HashSet();
    for (var p in widget.receipt.products) {
      final int count = skuGroup[p.sku]!;
      if (skus.contains(p.sku)) {
        continue;
      }

      skus.add(p.sku);
      productEntries.add(ReturnSelection(
        enabled: !_showingQRCode,
        product: p,
        size: count,
        onSelect: (pair) {
          setState(() {
            _pairs.remove(pair);
            _pairs.add(pair);
          });
        },
      ));
    }

    return getSection(
      context,
      "Products",
      productEntries,
      subtitle: "Select products you wish to return",
    );
  }

  Widget getSummary(BuildContext context) {
    return getSection(
      context,
      "Summary",
      subtitle: "Here is the summary of the return",
      [
        getSectionEntry("Number of products: ", refundAmount),
        getSectionEntry("Amount to be refunded: ", getTotalRefund()),
      ],
    );
  }

  Widget getSectionEntry(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: const TextStyle(fontWeight: FontWeight.w300),
          ),
          Text(
            right,
            style: const TextStyle(fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Map<Product, int> getPairsMap() {
    List<Selection> enabled = _pairs.toList().where((e) => e.enabled).toList();
    if (_pairs.isEmpty || enabled.isEmpty) {
      return {};
    }

    Map<Product, int> map = Map();
    for (final selection in enabled) {
      map[selection.product] = selection.quantity;
    }

    return map;
  }

  String get refundAmount {
    int count = 0;
    for (Selection pair in _pairs) {
      if (pair.enabled) {
        count += pair.quantity;
      }
    }
    return count.toString();
  }

  String getTotalRefund() {
    List<Selection> enabled = _pairs.toList().where((e) => e.enabled).toList();

    if (_pairs.isEmpty || enabled.isEmpty) {
      return CurrencyHelper.getFormatted(0, Currency.pound);
    }

    return CurrencyHelper.getFormatted(
        enabled
            .map((e) => e.product.price * e.quantity)
            .reduce((a, b) => a + b),
        Currency.pound); // TODO fix
  }
}
