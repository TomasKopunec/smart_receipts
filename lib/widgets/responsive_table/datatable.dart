import 'package:flutter/material.dart';
import 'package:smart_receipts/models/receipt.dart';
import 'package:smart_receipts/widgets/responsive_table/datatable_desktop_header.dart';
import 'data_entry_widget_desktop.dart';
import 'data_entry_widget_mobile.dart';

class ResponsiveDatatable extends StatefulWidget {
  final List<ReceiptAttribute> headers;
  final List<Map<String, dynamic>> source;
  final List<Map<String, dynamic>> selecteds;
  final List<Widget> actions;
  final List<Widget> footers;
  final bool isLoading;
  final List<bool> expanded;
  // Added
  final bool isSelecting;
  final Widget noDataWidget;
  final int total;
  final Color prefferedColor;

  // Const decoration for entries
  final BoxDecoration decoration = BoxDecoration(
      border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.1), width: 1)));

  ResponsiveDatatable(
      {super.key,
      required this.headers,
      required this.source,
      required this.selecteds,
      required this.actions,
      required this.footers,
      required this.isLoading,
      required this.expanded,
      required this.isSelecting,
      required this.noDataWidget,
      required this.total,
      required this.prefferedColor});

  @override
  State<ResponsiveDatatable> createState() => _ResponsiveDatatableState();
}

class _ResponsiveDatatableState extends State<ResponsiveDatatable> {
  LinearProgressIndicator get loadingIndicator {
    return LinearProgressIndicator(
      backgroundColor: widget.prefferedColor.withOpacity(0.5),
      color: widget.prefferedColor,
    );
  }

  /// List of widgets that is shown in the portrait mode
  List<Widget> get mobileList {
    return widget.total == 0
        ? [widget.noDataWidget]
        : widget.source
            .map((e) => DataEntryWidgetMobile(
                isSelecting: widget.isSelecting,
                color: widget.prefferedColor,
                data: e,
                headers: widget.headers))
            .toList();
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
      Container(
        decoration: widget.decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.actions,
        ),
      )
    ];

    if (isPortrait) {
      // Add the vertical list of children
      children.add(Column(
        children: [
          if (widget.isLoading) loadingIndicator,
          ...mobileList,
        ],
      ));

      // Add the footer
      children.add(Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widget.footers,
      ));
    } else {
      // Add the header
      if (widget.headers.isNotEmpty) {
        children.add(DatatableDesktopHeader(
            color: widget.prefferedColor,
            headers: widget.headers,
            decoration: widget.decoration));
      }

      // Add loading if needed
      if (widget.isLoading) {
        children.add(loadingIndicator);
      }

      // Add the children
      children.add(Column(children: desktopList));

      // Add the footers
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widget.footers,
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
