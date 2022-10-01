import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/widgets/table/receipt_status_label.dart';
import '../../../models/receipt.dart';

class DataEntryWidgetDesktop extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> data;
  final List<ReceiptAttribute> headers;
  final bool isSelecting;

  final Function(Map<String, dynamic> value)? onTabRow;

  const DataEntryWidgetDesktop(
      {required this.isSelecting,
      required this.color,
      required this.data,
      required this.headers,
      this.onTabRow});

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

  BoxDecoration get decoration {
    return BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: Colors.black.withOpacity(0.1), width: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTabRow?.call(widget.data);
      },
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: decoration,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.headers
              .map((e) => Expanded(child: getEntry(e.name)))
              .toList(),
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
        attribute == ReceiptAttribute.purchase_date) {
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
