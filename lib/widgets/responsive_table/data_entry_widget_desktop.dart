import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/widgets/receipt_status_label.dart';
import '../../../models/receipt.dart';

class DataEntryWidgetDesktop extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> data;
  final List<ReceiptAttribute> headers;
  final bool isSelecting;
  final bool isOdd;

  DataEntryWidgetDesktop(
      {required this.isSelecting,
      required this.color,
      required this.data,
      required this.headers,
      required this.isOdd})
      : super(key: ValueKey(data[ReceiptAttribute.uid.name]));

  @override
  State<DataEntryWidgetDesktop> createState() => _DataEntryWidgetDesktopState();

  String get uid {
    return data[ReceiptAttribute.uid.name];
  }
}

class _DataEntryWidgetDesktopState extends State<DataEntryWidgetDesktop> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();

    _isFavorite = Provider.of<ReceiptsProvider>(context, listen: false)
        .isFavorite(widget.uid);
  }

  bool get selected {
    return Provider.of<ReceiptsProvider>(context).selectedContains(widget.uid);
  }

  Widget get selectionIcon {
    Widget icon;

    final provider = Provider.of<ReceiptsProvider>(context);

    icon = widget.isSelecting
        ? provider.selectedContains(widget.uid)
            ? Icon(Icons.radio_button_checked,
                color: widget.color, size: SizeHelper.getIconSize(context))
            : Icon(Icons.radio_button_unchecked,
                color: widget.color, size: SizeHelper.getIconSize(context))
        : const Text('');

    final Widget view = InkWell(
        onTap: () {
          setState(() {
            if (provider.selectedContains(widget.uid)) {
              provider.removeSelectedByUID(widget.uid);
            } else {
              provider.addSelectedByUID(widget.uid);
            }
          });
        },
        child: Ink(child: icon));

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 0),
      child: AnimatedOpacity(
          opacity: widget.isSelecting ? 1 : 0,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: AnimatedScale(
              scale: widget.isSelecting ? 1 : 0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: view)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: widget.color.withOpacity(1 / 3),
      onTap: () {
        // Do something
      },
      child: Ink(
        child: Container(
          decoration: BoxDecoration(
              color: color,
              border: const Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.black26,
                ),
              )),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selectionIcon,
                ...widget.headers
                    .map((e) => Expanded(child: getEntry(e.name)))
                    .toList()
              ]),
        ),
      ),
    );
  }

  Color get color {
    if (selected) {
      return Colors.black12;
    } else {
      return widget.isOdd ? widget.color.withOpacity(0.075) : Colors.white;
    }
  }

  /// This container contains label for receipt status and also favorite status
  Widget getStatusWidget(ReceiptStatus status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: [
          ReceiptStatusLabel(status: status),
          const SizedBox(height: 2),
          favoriteLabel
        ],
      ),
    );
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
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: SizeHelper.getIconSize(context, size: IconSize.small),
                ),
                const SizedBox(width: 1),
                Text(
                  'Favorite',
                  style: TextStyle(
                      fontSize: SizeHelper.getFontSize(context,
                          size: FontSize.small)),
                )
              ],
            )),
      ),
    );
  }

  Widget getEntry(String header) {
    final ReceiptAttribute attribute = ReceiptAttribute.from(header);
    final value = widget.data[attribute.name];

    if (attribute == ReceiptAttribute.status) {
      return getStatusWidget(ReceiptStatus.from(value));
    }

    String formattedString = '$value';

    if (attribute == ReceiptAttribute.expiration ||
        attribute == ReceiptAttribute.purchaseDate) {
      formattedString = DateFormat.yMMMMd().format(DateTime.parse(value));
    }

    if (attribute == ReceiptAttribute.amount) {
      formattedString = '$value\$';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Text(
        formattedString,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }
}
