import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/widgets/table/responsive_table/table_dismissible.dart';
import '../../../models/receipt.dart';
import '../receipt_status_label.dart';
import 'datatable.dart';
import 'datatable_header.dart';

class DataEntryWidget extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> data;
  final List<DatatableHeader> headers;
  final bool commonMobileView;
  final Function(Map<String, dynamic>)? dropContainer;
  final Function(bool) onSelected;
  final bool isSelecting;

  DataEntryWidget({
    required this.isSelecting,
    required this.color,
    required this.data,
    required this.headers,
    required this.commonMobileView,
    required this.dropContainer,
    required this.onSelected,
  });

  @override
  State<DataEntryWidget> createState() => _DataEntryWidgetState();

  String get uid {
    return data[ReceiptAttribute.uid.name];
  }
}

class _DataEntryWidgetState extends State<DataEntryWidget> {
  bool _isExpanded = false;

  // late double iconHeight;

  @override
  void initState() {
    super.initState();
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
        child: TableDismissible(
          color: widget.color,
          key: ValueKey(widget.uid),
          child: ExpansionTile(
            onExpansionChanged: (value) {
              setState(() {
                _isExpanded = value;
              });
            },
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [selectionIcon, SizedBox(width: 10), expansionIcon],
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
                    color: widget.color,
                    status: ReceiptStatus.from(
                        widget.data[ReceiptAttribute.status.name]))
              ],
            ),
            trailing: Text(
                '${widget.data[ReceiptAttribute.amount.name].toString()}\$'),
            textColor: widget.color,
            iconColor: widget.color,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.commonMobileView && widget.dropContainer != null)
                    widget.dropContainer!(widget.data),
                  if (!widget.commonMobileView)
                    ...widget.headers
                        .where((header) => header.show == true)
                        .toList()
                        .map((header) => getEntry(header, widget.data))
                        .toList(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const Spacer(),
                        IconButton(
                          onPressed: _deleteReceipt,
                          icon: const Icon(Icons.delete),
                          color: widget.color,
                        ),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.color,
                            ),
                            onPressed: _showReceipt,
                            icon: const Icon(Icons.receipt),
                            label: const Text("Show Receipt")),

                        Checkbox(
                            activeColor: widget.color,
                            value: selected,
                            onChanged: (value) => widget.onSelected(value!)),
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

  void _deleteReceipt() {
    print('Delete receipt with UID: ${widget.uid}');
  }

  void _showReceipt() {
    print('Show receipt with UID: ${widget.uid}');
  }

  Widget getEntry(DatatableHeader header, Map<String, dynamic> data) {
    final bool isDate =
        header.value.toString().toLowerCase().contains('date') ||
            header.value.toString().toLowerCase().contains('expiration');
    final bool isAmount =
        header.value.toString().toLowerCase().contains("amount");

    String stringOutput = '${data[header.value]}';
    if (isDate) {
      stringOutput = DateFormat.yMMMMd().format(DateTime.parse(stringOutput));
    }
    if (isAmount) {
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
                  header.text,
                  overflow: TextOverflow.clip,
                ),
                const Spacer(),
                header.editable
                    ? TextEditableWidget(
                        data: data,
                        header: header,
                        textAlign: TextAlign.end,
                      )
                    : Text(stringOutput)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
