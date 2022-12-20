import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/screens/show_receipt_screen.dart';
import '../../models/receipt/receipt.dart';

import '../../models/product/product.dart';

import '../receipt_status_label.dart';
import 'entry_dismissible.dart';

class DataEntryWidgetMobile extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> data;
  final List<ReceiptField> headers;
  final bool isSelecting;

  late double iconSize;

  DataEntryWidgetMobile({
    required this.isSelecting,
    required this.color,
    required this.data,
    required this.headers,
  }) : super(key: ValueKey(data['id']));

  @override
  State<DataEntryWidgetMobile> createState() => _DataEntryWidgetMobileState();

  int get id {
    return data['id'];
  }
}

class _DataEntryWidgetMobileState extends State<DataEntryWidgetMobile> {
  late ReceiptsProvider _provider;
  bool _isExpanded = false;
  // late bool _isFavourite;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ReceiptsProvider>(context, listen: false);

    // Listen to changes
    _provider.addListener(() {
      setState(() {
        // Rebuild
      });
    });
  }

  Widget get leading {
    return _provider.isSelecting ? selectionIcon : _expansionIcon;
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
        ? _provider.selectedContains(widget.id)
            ? Icon(Icons.radio_button_checked,
                color: widget.color, size: SizeHelper.getIconSize(context))
            : Icon(Icons.radio_button_unchecked,
                color: widget.color, size: SizeHelper.getIconSize(context))
        : const Text('');

    final Widget view = InkWell(
        onTap: () {
          setState(() {
            if (_provider.selectedContains(widget.id)) {
              _provider.removeSelectedByID(widget.id);
            } else {
              _provider.addSelectedByID(widget.id);
            }
          });
        },
        child: Ink(child: icon));

    return view;
  }

  bool get _isSelected {
    return _provider.selectedContains(widget.id);
  }

  bool get _isFavourite {
    return _provider.isFavorite(widget.id);
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
    final decoration = BoxDecoration(
      color: _isSelected ? widget.color.withOpacity(0.4) : Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      boxShadow: [
        BoxShadow(
            color: _isSelected ? Colors.white : Colors.black.withOpacity(0.35),
            blurRadius: _isSelected ? 0 : 1.5,
            offset: Offset(0, _isSelected ? 0 : 1.5)),
      ],
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
      decoration: decoration,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: EntryDismissible(
          id: widget.id,
          color: widget.color,
          child: ExpansionTile(
            leading: leading,
            backgroundColor: widget.color.withOpacity(0.1),
            onExpansionChanged: (value) => setState(() {
              _isExpanded = value;
            }),
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            key: ValueKey(widget.id),
            tilePadding: const EdgeInsets.only(left: 10, right: 20),
            controlAffinity: ListTileControlAffinity.leading,
            title: Row(
              children: [
                Text(
                  widget.data[ReceiptField.retailer_name.name],
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(numberOfItems),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.parse(
                    widget.data[ReceiptField.purchase_date_time.name]))),
              ],
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '£${widget.data[ReceiptField.price.name].toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeHelper.getFontSize(context,
                          size: FontSize.regularLarge)),
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
            textColor: widget.color,
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
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.color,
                        ),
                        onPressed: _showReceipt,
                        icon: const Icon(Icons.receipt),
                        label: const Text("Show Receipt")),
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
    final value = widget.data[header];

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
                Text(
                  header.toString(),
                  overflow: TextOverflow.clip,
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
    if (header == ReceiptField.purchase_date_time ||
        header == ReceiptField.expiration) {
      stringOutput = DateFormat.yMMMMd().format(DateTime.parse(stringOutput));
    } else if (header == ReceiptField.price) {
      stringOutput = ('${value.toStringAsFixed(2)}\$');
    } else if (header == ReceiptField.products) {
      stringOutput = '${widget.data[ReceiptField.products.name].length}';
    }
    return Text(stringOutput);
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }
}
