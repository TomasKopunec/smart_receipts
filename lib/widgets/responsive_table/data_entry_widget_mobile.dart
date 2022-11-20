import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/screens/show_receipt_screen.dart';
import '../../../models/receipt.dart';
import '../receipt_status_label.dart';
import 'entry_dismissible.dart';

class DataEntryWidgetMobile extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> data;
  final List<ReceiptAttribute> headers;
  final bool isSelecting;

  late double iconSize;

  DataEntryWidgetMobile({
    required this.isSelecting,
    required this.color,
    required this.data,
    required this.headers,
  }) : super(key: ValueKey(data[ReceiptAttribute.uid.name]));

  @override
  State<DataEntryWidgetMobile> createState() => _DataEntryWidgetMobileState();

  String get uid {
    return data[ReceiptAttribute.uid.name];
  }
}

class _DataEntryWidgetMobileState extends State<DataEntryWidgetMobile> {
  late ReceiptsProvider _provider;
  bool _isExpanded = false;
  late bool _isFavourite;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ReceiptsProvider>(context, listen: false);
    _isFavourite = _provider.isFavorite(widget.uid);
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
        ? _provider.selectedContains(widget.uid)
            ? Icon(Icons.radio_button_checked,
                color: widget.color, size: SizeHelper.getIconSize(context))
            : Icon(Icons.radio_button_unchecked,
                color: widget.color, size: SizeHelper.getIconSize(context))
        : const Text('');

    final Widget view = InkWell(
        onTap: () {
          setState(() {
            if (_provider.selectedContains(widget.uid)) {
              _provider.removeSelectedByUID(widget.uid);
            } else {
              _provider.addSelectedByUID(widget.uid);
            }
          });
        },
        child: Ink(child: icon));

    return view;
  }

  bool get isSelected {
    return Provider.of<ReceiptsProvider>(context).selectedContains(widget.uid);
  }

  Widget get favoriteLabel {
    final provider = Provider.of<ReceiptsProvider>(context);

    provider.addListener(
      () {
        final bool result = provider.isFavorite(widget.uid);
        if (result != _isFavourite) {
          setState(() {
            _isFavourite = result;
          });
        }
      },
    );

    return AnimatedOpacity(
        duration: const Duration(milliseconds: 1200),
        curve: Curves.fastLinearToSlowEaseIn,
        opacity: _isFavourite ? 1 : 0,
        child: const Icon(Icons.star, color: Colors.yellow));
  }

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: isSelected ? widget.color.withOpacity(0.4) : Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      boxShadow: [
        BoxShadow(
            color: isSelected ? Colors.white : Colors.black.withOpacity(0.25),
            blurRadius: isSelected ? 0 : 1,
            offset: Offset(0, isSelected ? 0 : 1)),
      ],
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
      decoration: decoration,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: EntryDismissible(
          uid: widget.uid,
          color: widget.color,
          child: ExpansionTile(
            leading: leading,
            backgroundColor: widget.color.withOpacity(0.1),
            onExpansionChanged: (value) => setState(() {
              _isExpanded = value;
            }),
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            key: ValueKey(widget.uid),
            tilePadding: const EdgeInsets.only(left: 10, right: 20),
            controlAffinity: ListTileControlAffinity.leading,
            title: Row(
              children: [
                Text(widget.data[ReceiptAttribute.storeName.name]),
                const SizedBox(
                  width: 2,
                ),
                const Icon(Icons.location_on),
                Text(widget.data[ReceiptAttribute.storeLocation.name]),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.parse(
                    widget.data[ReceiptAttribute.purchaseDate.name]))),
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
    if (attribute == ReceiptAttribute.purchaseDate ||
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

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }
}
