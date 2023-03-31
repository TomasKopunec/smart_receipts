import 'dart:collection';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/currency_helper.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/product/product.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/models/return/return.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/screens/show_receipt_screen.dart';
import 'package:smart_receipts/widgets/return_status_label.dart';

enum FieldType {
  price,
  integer,
  date,
  status,
  string;
}

class ReturnItemDto {
  final Product product;
  final int quantity;

  ReturnItemDto({
    required this.product,
    required this.quantity,
  });

  @override
  int get hashCode {
    return product.sku.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return (other is ReturnItemDto) && (other.product.sku == other.product.sku);
  }
}

class ReturnsEntry extends StatefulWidget {
  final Receipt receipt;
  final Return returnEntry;
  final Currency currency;

  const ReturnsEntry({
    super.key,
    required this.receipt,
    required this.returnEntry,
    required this.currency,
  });

  String get id {
    return returnEntry.getField(ReturnField.receiptId);
  }

  @override
  State<ReturnsEntry> createState() => _ReturnsEntryState();
}

class _ReturnsEntryState extends State<ReturnsEntry> {
  late final ReceiptsProvider _receiptProvider;
  late final SettingsProvider _settingsProvider;
  bool _isExpanded = false;
  // late bool _isFavourite;

  final int index = Random().nextInt(ReturnStatus.values.length);

  @override
  void initState() {
    super.initState();

    _receiptProvider = Provider.of<ReceiptsProvider>(context, listen: false);
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    // Listen to changes
    _receiptProvider.addListener(() {
      setState(() {});
    });
    _settingsProvider.addListener(() {
      setState(() {});
    });
  }

  Widget get leading {
    return _expansionIcon;
  }

  Widget get _expansionIcon {
    return AnimatedRotation(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastLinearToSlowEaseIn,
      turns: _isExpanded ? 0.5 : 0,
      child: Icon(
        Icons.expand_less,
        size: SizeHelper.getIconSize(context),
      ),
    );
  }

  String get numberOfItems {
    final int count = widget.receipt.getProductsCount();
    return count == 1 ? '(1 product)' : '($count products)';
  }

  String get titleText {
    final numberOfReturnedItems = widget.returnEntry.numberOfReturnedItems;
    return '${widget.receipt.retailerName} ($numberOfReturnedItems item${numberOfReturnedItems == 1 ? "" : "s"})';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.zero,
        elevation: 3,
        child: ExpansionTile(
          leading: leading,
          onExpansionChanged: (value) => setState(() {
            _isExpanded = value;
          }),
          key: ValueKey(widget.id),
          tilePadding: const EdgeInsets.only(left: 10, right: 20),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            titleText,
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
          ),

          subtitle: Opacity(
            opacity: 0.75,
            child: Text(
              DateFormat(_settingsProvider.dateTimeFormat.format)
                  .format(widget.returnEntry.recentDateTime),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w400),
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
            ),
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                CurrencyHelper.getFormatted(
                  price: widget.returnEntry.refundedAmount,
                  originCurrency: widget.currency,
                  targetCurrency: _settingsProvider.currency,
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          //  textColor: widget.color,
          iconColor: Theme.of(context).primaryColor,
          children: [
            Column(mainAxisSize: MainAxisSize.min, children: getChildren()),
          ],
        ),
      ),
    );
  }

  List<Widget> getChildren() {
    List<Widget> widgets = [];

    // widgets.add(getEntry("Receipt ID", FieldType.string, widget.id));

    widgets.add(getEntry(
        "Refund Amount", FieldType.price, widget.returnEntry.refundedAmount));

    widgets.add(
        getEntry("Date", FieldType.date, widget.returnEntry.recentDateTime));

    widgets.add(
        getEntry("Method", FieldType.string, widget.receipt.paymentMethod));

    if (widget.receipt.paymentMethod.toLowerCase() == 'card') {
      widgets.add(getEntry("Card Number", FieldType.string,
          "•••• •••• •••• ${widget.receipt.cardNumber!.substring(widget.receipt.cardNumber!.length - 4)}"));
    }

    widgets.add(getEntry("Status", FieldType.status, index));

    widgets.add(getEntry("Number Of Items", FieldType.integer,
        widget.returnEntry.numberOfReturnedItems));

    widgets.add(getEntry("Returned Items:", FieldType.string, ""));
    widgets.add(const SizedBox(height: 6));

    // Mapping of SKUs to Products
    Set<ReturnItemDto> items = HashSet();
    for (final item in widget.returnEntry.returnedItems) {
      final dto = ReturnItemDto(
          product: widget.receipt.findProductBySku(item.sku),
          quantity: item.quantity);

      if (!items.contains(dto)) {
        items.add(dto);
      }
    }

    for (var e in items) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: getEntry(
            "${e.product.name} (${e.quantity} x ${e.product.price}) ",
            FieldType.price,
            e.product.price * e.quantity,
            includeDivider: false),
      ));
    }

    widgets.add(Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: _showReceipt,
                icon: const Icon(Icons.receipt),
                label: const Text("Show Original Receipt")),
          )
        ],
      ),
    ));

    return widgets;
  }

  void _showReceipt() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ShowReceiptScreen(),
          settings: RouteSettings(arguments: widget.id),
        ));
  }

  Widget getEntry(String name, FieldType valueType, dynamic value,
      {bool includeDivider = true}) {
    return Theme(
      data: Theme.of(context)
          .copyWith(dividerColor: Colors.black.withOpacity(0.2)),
      child: Column(
        children: [
          if (includeDivider) const Divider(thickness: 0.5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeHelper.getFontSize(context)),
                ),
                const Spacer(),
                getValueWidget(valueType, value)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getValueWidget(FieldType type, dynamic value) {
    String stringOutput = '$value';

    switch (type) {
      case FieldType.price:
        stringOutput = CurrencyHelper.getFormatted(
            price: value,
            originCurrency: widget.currency,
            targetCurrency: _settingsProvider.currency);
        break;
      case FieldType.date:
        stringOutput = DateFormat(_settingsProvider.dateTimeFormat.format)
            .format(DateTime.parse(stringOutput));
        break;
      case FieldType.status:
        return ReturnStatusLabel(index: value);
      case FieldType.integer:
      case FieldType.string:
        break;
    }
    return AutoSizeText(stringOutput,
        maxLines: 1,
        overflow: TextOverflow.fade,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w300,
            fontSize: SizeHelper.getFontSize(context)));
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }
}
