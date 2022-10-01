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
    return InkWell(
      splashColor: widget.color.withOpacity(1 / 3),
      onTap: () {
        // Do something
      },
      child: Ink(
        child: Container(
          color: widget.isOdd
              ? widget.color.withOpacity(0.075)
              : Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.headers
                .map((e) => Expanded(child: getEntry(e.name)))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget getStatusWidget(ReceiptStatus status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ReceiptStatusLabel(status: status),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        formattedString,
        textAlign: TextAlign.center,
      ),
    );
  }
}
