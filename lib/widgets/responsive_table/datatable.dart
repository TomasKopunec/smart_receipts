import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/widgets/responsive_table/datatable_desktop_header.dart';
import 'data_entry_widget_desktop.dart';
import 'data_entry_widget_mobile.dart';

class ResponsiveDatatable extends StatefulWidget {
  final List<ReceiptField> headers;
  final List<Map<String, dynamic>> source;
  // Added
  final bool isSelecting;
  final Widget noDataWidget;
  final int total;
  final Color prefferedColor;

  final bool isSortingByDate;

  final Color backgroundColor;

  // Const decoration for entries
  final BoxDecoration decoration = BoxDecoration(
      border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.1), width: 1)));

  ResponsiveDatatable(
      {super.key,
      required this.isSortingByDate,
      required this.headers,
      required this.source,
      required this.isSelecting,
      required this.noDataWidget,
      required this.total,
      required this.prefferedColor,
      this.backgroundColor = Colors.transparent});

  @override
  State<ResponsiveDatatable> createState() => _ResponsiveDatatableState();
}

class _ResponsiveDatatableState extends State<ResponsiveDatatable> {
  /// List of widgets that is shown in the portrait mode
  List<Widget> get mobileList {
    return getList();
  }

  List<Widget> getList() {
    if (widget.isSortingByDate) {
      List<Widget> widgets = [];
      LinkedHashMap<String, List<dynamic>> groupping = LinkedHashMap();

      // Group by month-year
      for (final Map<String, dynamic> entry in widget.source) {
        final parsedDate =
            DateTime.parse(entry[ReceiptField.purchase_date_time.name]);
        final String key =
            "${DateFormat.MMMM().format(DateTime(0, parsedDate.month))}, ${parsedDate.year}";

        groupping.update(
          key,
          (value) {
            value.add(entry);
            return value;
          },
          ifAbsent: () {
            groupping[key] = [entry];
            return [entry];
          },
        );
      }

      for (final value in groupping.entries) {
        final String text = value.key;
        final List<dynamic> entries = value.value;

        widgets.add(Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ));

        entries.forEach((e) {
          widgets.add(DataEntryWidgetMobile(
              isSelecting: widget.isSelecting,
              color: widget.prefferedColor,
              data: e,
              headers: widget.headers));
        });
      }
      return widgets;
    } else {
      return widget.source
          .map((e) => DataEntryWidgetMobile(
              isSelecting: widget.isSelecting,
              color: widget.prefferedColor,
              data: e,
              headers: widget.headers))
          .toList();
    }
  }

  /// List of widgets that is shown in landscape mode
  List<Widget> get desktopList {
    if (widget.total == 0) {
      return [widget.noDataWidget];
    }

    final List<Widget> entries = [];

    for (int i = 0; i < widget.source.length; i++) {
      entries.add(DataEntryWidgetDesktop(
          isOdd: i.isOdd,
          isSelecting: widget.isSelecting,
          color: widget.prefferedColor,
          data: widget.source[i],
          headers: widget.headers));
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    List<Widget> children = [
      Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      )
    ];

    if (isPortrait) {
      // Add the vertical list of children
      children.add(Container(
        color: widget.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 1),
            ...mobileList,
          ],
        ),
      ));

      // Add the footer
      children.add(Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
        ),
      ));
    } else {
      // Add the header
      if (widget.headers.isNotEmpty) {
        children.add(DatatableDesktopHeader(
            isSelecting: widget.isSelecting,
            color: widget.prefferedColor,
            headers: widget.headers,
            decoration: widget.decoration));
      }

      // Add the children
      children.add(Column(children: desktopList));

      // Add the footers
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
