import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

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
  final bool selected;

  const DataEntryWidget({
    required this.color,
    required this.selected,
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
  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8)),
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
        child: ExpansionTile(
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
          subtitle: Text(DateFormat.yMMMMd().format(DateTime.parse(
              widget.data[ReceiptAttribute.purchase_date.name]))),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${widget.data[ReceiptAttribute.amount.name].toString()}\$'),
              const SizedBox(height: 2),
              ReceiptStatusLabel(
                  color: widget.color,
                  status: ReceiptStatus.from(
                      widget.data[ReceiptAttribute.status.name]))
            ],
          ),
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
                          value: widget.selected,
                          onChanged: (value) => widget.onSelected(value!)),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
