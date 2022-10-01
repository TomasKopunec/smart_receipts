import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/screens/show_receipt_screen.dart';
import 'package:smart_receipts/widgets/table/responsive_table/entry_dismissible.dart';
import '../../../models/receipt.dart';
import '../receipt_status_label.dart';

class DataEntryWidgetMobile extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> data;
  final List<ReceiptAttribute> headers;
  final Function(bool) onSelected;
  final bool isSelecting;

  DataEntryWidgetMobile({
    required this.isSelecting,
    required this.color,
    required this.data,
    required this.headers,
    required this.onSelected,
  });

  @override
  State<DataEntryWidgetMobile> createState() => _DataEntryWidgetMobileState();

  String get uid {
    return data[ReceiptAttribute.uid.name];
  }
}

class _DataEntryWidgetMobileState extends State<DataEntryWidgetMobile> {
  bool _isExpanded = false;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();

    _isFavorite = Provider.of<ReceiptsProvider>(context, listen: false)
        .isFavorite(widget.uid);
  }

  Widget get expansionIcon {
    return AnimatedRotation(
        alignment: Alignment.center,
        turns: _isExpanded ? 0 : -0.5,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut,
        child: Icon(Icons.expand_less));
  }

  Widget get selectionIcon {
    const animDuration = Duration(milliseconds: 800);
    const animCurve = Curves.fastLinearToSlowEaseIn;
    Widget icon;

    final provider = Provider.of<ReceiptsProvider>(context);

    icon = widget.isSelecting
        ? provider.selectedContains(widget.uid)
            ? Icon(Icons.radio_button_checked, color: widget.color)
            : Icon(Icons.radio_button_unchecked, color: widget.color)
        : Text('');

    return AnimatedScale(
      scale: widget.isSelecting ? 1 : 0,
      duration: animDuration,
      curve: animCurve,
      child: AnimatedOpacity(
          opacity: widget.isSelecting ? 1 : 0,
          duration: animDuration,
          curve: animCurve,
          child: InkWell(
              onTap: () {
                setState(() {
                  if (provider.selectedContains(widget.uid)) {
                    provider.removeSelectedByUID(widget.uid);
                  } else {
                    provider.addSelectedByUID(widget.uid);
                  }
                });
              },
              child: Ink(child: icon))),
    );
  }

  bool get selected {
    return Provider.of<ReceiptsProvider>(context).selectedContains(widget.uid);
  }

  Widget get favoriteLabel {
    const animDuration = Duration(seconds: 3);
    const animCurve = Curves.fastLinearToSlowEaseIn;
    final double iconHeight =
        SizeHelper.getFontSize(context, size: FontSize.larger);

    final provider = Provider.of<ReceiptsProvider>(context);
    provider.addListener(
      () {
        if (provider.isFavorite(widget.uid) != _isFavorite) {
          setState(() {
            _isFavorite = provider.isFavorite(widget.uid);
          });
        }
      },
    );

    return AnimatedContainer(
      duration: animDuration,
      curve: animCurve,
      height: _isFavorite ? iconHeight : 0,
      child: AnimatedScale(
        scale: _isFavorite ? 1 : 0,
        duration: animDuration,
        curve: animCurve,
        child: AnimatedOpacity(
            opacity: _isFavorite ? 1 : 0,
            duration: animDuration,
            curve: animCurve,
            child: const Icon(Icons.star, color: Colors.yellow)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: selected ? Colors.grey.shade200 : Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      boxShadow: [
        BoxShadow(
            color: widget.color.withOpacity(0.3),
            blurRadius: 1.5,
            offset: const Offset(0, 2.5)),
      ],
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 8, left: 6, right: 6),
      decoration: decoration,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: EntryDismissible(
          uid: widget.uid,
          color: widget.color,
          child: ExpansionTile(
            onExpansionChanged: (value) {
              setState(() {
                _isExpanded = value;
              });
            },
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                selectionIcon,
                const SizedBox(width: 10),
                expansionIcon
              ],
            ),
            backgroundColor: widget.color.withOpacity(0.1),
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            key: ValueKey(widget.uid),
            tilePadding: const EdgeInsets.only(left: 10, right: 20),
            controlAffinity: ListTileControlAffinity.leading,
            title: Row(
              children: [
                Text(widget.data[ReceiptAttribute.store_name.name]),
                const SizedBox(
                  width: 2,
                ),
                const Icon(Icons.location_on),
                Text(widget.data[ReceiptAttribute.store_location.name]),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.parse(
                    widget.data[ReceiptAttribute.purchase_date.name]))),
                const SizedBox(width: 8),
                ReceiptStatusLabel(
                    status: ReceiptStatus.from(
                        widget.data[ReceiptAttribute.status.name]))
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    '${widget.data[ReceiptAttribute.amount.name].toString()}\$'),
                favoriteLabel
              ],
            ),
            textColor: widget.color,
            iconColor: widget.color,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...widget.headers.map((e) => getEntry(e.name)).toList(),
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
          settings: RouteSettings(arguments: widget.uid),
        ));
  }

  Widget getEntry(String header) {
    final ReceiptAttribute attribute = ReceiptAttribute.from(header);
    final value = widget.data[attribute.name];

    String stringOutput = '$value';
    if (attribute == ReceiptAttribute.purchase_date ||
        attribute == ReceiptAttribute.expiration) {
      stringOutput = DateFormat.yMMMMd().format(DateTime.parse(stringOutput));
    }
    if (attribute == ReceiptAttribute.amount) {
      stringOutput = '$stringOutput\$';
    }

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
                  attribute.toString(),
                  overflow: TextOverflow.clip,
                ),
                const Spacer(),
                attribute == ReceiptAttribute.status
                    ? ReceiptStatusLabel(status: ReceiptStatus.from(value))
                    : Text(stringOutput)
              ],
            ),
          ),
        ],
      ),
    );
  }
}