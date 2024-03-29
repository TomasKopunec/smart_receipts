import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/screens/show_receipt_screen.dart';
import '../../../../helpers/currency_helper.dart';
import '../../../../models/receipt/receipt.dart';

import '../../../../widgets/receipt_status_label.dart';
import 'entry_dismissible.dart';

class DataEntryWidgetMobile extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> data;
  final List<ReceiptField> headers;
  final bool isSelecting;

  DataEntryWidgetMobile({
    required this.isSelecting,
    required this.color,
    required this.data,
    required this.headers,
  }) : super(key: ValueKey(data[ReceiptField.receiptId.name]));

  @override
  State<DataEntryWidgetMobile> createState() => _DataEntryWidgetMobileState();

  String get id {
    return data[ReceiptField.receiptId.name];
  }
}

class _DataEntryWidgetMobileState extends State<DataEntryWidgetMobile> {
  late final ReceiptsProvider _receiptProvider;
  late final SettingsProvider _settingsProvider;
  bool _isExpanded = false;
  // late bool _isFavourite;

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
    return _receiptProvider.isSelecting ? selectionIcon : _expansionIcon;
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

  Widget get selectionIcon {
    Widget icon;

    icon = widget.isSelecting
        ? _receiptProvider.selectedContains(widget.id)
            ? Icon(Icons.radio_button_checked,
                color: widget.color, size: SizeHelper.getIconSize(context))
            : Icon(Icons.radio_button_unchecked,
                color: widget.color, size: SizeHelper.getIconSize(context))
        : const Text('');

    final Widget view = InkWell(
        onTap: () {
          setState(() {
            if (_receiptProvider.selectedContains(widget.id)) {
              _receiptProvider.removeSelectedByID(widget.id);
            } else {
              _receiptProvider.addSelectedByID(widget.id);
            }
          });
        },
        child: Ink(child: icon));

    return view;
  }

  bool get _isFavourite {
    return _receiptProvider.isFavorite(widget.id);
  }

  Widget get favoriteLabel {
    return AnimatedOpacity(
        duration: const Duration(milliseconds: 1200),
        curve: Curves.fastLinearToSlowEaseIn,
        opacity: _isFavourite ? 1 : 0,
        child: const Icon(Icons.star, color: Color.fromARGB(255, 255, 187, 0)));
  }

  String get numberOfItems {
    final int count = widget.data[ReceiptField.products.name].length;
    return count == 1 ? '(1 product)' : '($count products)';
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
        child: EntryDismissible(
          id: widget.id,
          color: widget.color,
          child: ExpansionTile(
            leading: leading,
            onExpansionChanged: (value) => setState(() {
              _isExpanded = value;
            }),
            key: ValueKey(widget.id),
            tilePadding: const EdgeInsets.only(left: 10, right: 20),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              '${widget.data[ReceiptField.retailerName.name]}  $numberOfItems',
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
            ),

            subtitle: Opacity(
              opacity: 0.75,
              child: Text(
                DateFormat(_settingsProvider.dateTimeFormat.format).format(
                    DateTime.parse(
                        widget.data[ReceiptField.purchaseDateTime.name])),
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
                      price: widget.data[ReceiptField.price.name],
                      originCurrency: Currency.from(
                          widget.data[ReceiptField.currency.name]),
                      targetCurrency: _settingsProvider.currency),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_isFavourite)
                  Row(
                    children: [
                      const SizedBox(width: 2),
                      favoriteLabel,
                    ],
                  )
              ],
            ),
            //  textColor: widget.color,
            iconColor: widget.color,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...widget.headers.map((e) => getEntry(e)).toList(),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.black.withOpacity(0.2)),
                    child: Column(
                      children: [
                        const Divider(thickness: 0.5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Number of Products',
                                overflow: TextOverflow.clip,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                            SizeHelper.getFontSize(context)),
                              ),
                              const Spacer(),
                              getValueWidget(
                                  ReceiptField.products,
                                  widget
                                      .data[ReceiptField.products.name].length)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 4, left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.color,
                              ),
                              onPressed: _showReceipt,
                              icon: const Icon(Icons.receipt),
                              label: const Text("Show Receipt")),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReceipt() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ShowReceiptScreen(),
          settings: RouteSettings(arguments: widget.id),
        ));
  }

  Widget getEntry(ReceiptField header) {
    return Theme(
      data: Theme.of(context)
          .copyWith(dividerColor: Colors.black.withOpacity(0.2)),
      child: Column(
        children: [
          const Divider(thickness: 0.5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  header.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeHelper.getFontSize(context)),
                ),
                const Spacer(),
                getValueWidget(header, widget.data[header.name])
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getValueWidget(ReceiptField header, dynamic value) {
    if (header == ReceiptField.status) {
      return ReceiptStatusLabel(status: ReceiptStatus.from(value));
    }

    String stringOutput = '$value';
    if (header == ReceiptField.purchaseDateTime ||
        header == ReceiptField.expiration) {
      stringOutput = DateFormat(_settingsProvider.dateTimeFormat.format)
          .format(DateTime.parse(stringOutput));
    } else if (header == ReceiptField.price) {
      stringOutput = CurrencyHelper.getFormatted(
          price: value,
          originCurrency:
              Currency.from(widget.data[ReceiptField.currency.name]),
          targetCurrency: _settingsProvider.currency);
    } else if (header == ReceiptField.products) {
      stringOutput = '${widget.data[ReceiptField.products.name].length}';
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
