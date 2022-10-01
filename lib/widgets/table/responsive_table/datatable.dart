import 'package:adaptivex/adaptivex.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_receipts/models/receipt.dart';
import 'package:smart_receipts/widgets/table/responsive_table/data_entry_widget_desktop.dart';
import 'data_entry_widget_mobile.dart';

class ResponsiveDatatable extends StatefulWidget {
  final Widget noDataWidget;
  final List<ReceiptAttribute> headers;
  final List<Map<String, dynamic>>? source;
  final List<Map<String, dynamic>>? selecteds;
  final int total;
  final Widget? title;
  final List<Widget>? actions;
  final List<Widget>? footers;
  final Function(bool? value)? onSelectAll;
  final Function(bool? value, Map<String, dynamic> data)? onSelect;
  final Function(Map<String, dynamic> value)? onTabRow;
  final Function(dynamic value)? onSort;
  final String? sortColumn;
  final bool? sortAscending;
  final bool isLoading;
  final bool autoHeight;
  final bool isSelecting;
  final bool hideUnderline;
  final bool commonMobileView;
  final bool isExpandRows;
  final List<bool> expanded;
  final Widget Function(Map<String, dynamic> value)? dropContainer;
  final List<ScreenSize> reponseScreenSizes;

  /// Color to be used
  final Color prefferedColor;

  const ResponsiveDatatable(
      {Key? key,
      required this.noDataWidget,
      this.onSelectAll,
      this.onSelect,
      this.onTabRow,
      this.onSort,
      this.headers = const [],
      this.source,
      required this.total,
      this.selecteds,
      this.title,
      this.actions,
      this.footers,
      this.sortColumn,
      this.sortAscending,
      this.isLoading = false,
      this.autoHeight = true,
      this.hideUnderline = true,
      this.commonMobileView = false,
      this.isExpandRows = true,
      required this.expanded,
      this.dropContainer,
      required this.isSelecting,
      this.reponseScreenSizes = const [
        ScreenSize.xs,
        ScreenSize.sm,
        ScreenSize.md
      ],
      required this.prefferedColor})
      : super(key: key);

  @override
  _ResponsiveDatatableState createState() => _ResponsiveDatatableState();
}

class _ResponsiveDatatableState extends State<ResponsiveDatatable> {
  bool get areAllSelected {
    return widget.total == widget.selecteds!.length &&
        widget.source != null &&
        widget.source!.isNotEmpty;
  }

  List<Widget> mobileList() {
    if (widget.total == 0) {
      return [widget.noDataWidget];
    }

    final List<Widget> list = [
      const SizedBox(
        height: 8,
      )
    ];

    for (var i = 0; i < widget.source!.length; i++) {
      final data = widget.source!.elementAt(i);

      list.add(DataEntryWidgetMobile(
          isSelecting: widget.isSelecting,
          // selected: widget.selecteds!.contains(data),
          color: widget.prefferedColor,
          data: data,
          headers: widget.headers,
          onSelected: (value) {
            if (widget.onSelect != null) {
              widget.onSelect!(value, data);
            }
          }));
    }
    return list;
  }

  Widget getEntry(String header, Map<String, dynamic> data) {
    final bool isDate = header.toString().toLowerCase().contains('date') ||
        header.toString().toLowerCase().contains('expiration');
    final bool isAmount = header.toString().toLowerCase().contains("amount");

    String stringOutput = '${data[header]}';
    if (isDate) {
      stringOutput = DateFormat.yMMMMd().format(DateTime.parse(stringOutput));
    }
    if (isAmount) {
      stringOutput = '$stringOutput\$';
    }

    return Column(
      children: [
        const Divider(thickness: 0.75),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header,
                overflow: TextOverflow.clip,
              ),
              const Spacer(),
              Text(stringOutput)
              // header.editable
              //     ? TextEditableWidget(
              //         data: data,
              //         header: header,
              //         textAlign: TextAlign.end,
              //         onChanged: widget.onChangedRow,
              //         onSubmitted: widget.onSubmittedRow,
              //         hideUnderline: widget.hideUnderline,
              //       )
              //     : Text(stringOutput)
            ],
          ),
        ),
      ],
    );
  }

  static Alignment headerAlignSwitch(TextAlign? textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }

  Widget desktopHeader() {
    final headerDecoration = BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: Colors.black.withOpacity(0.1), width: 1)));

    return Container(
      decoration: headerDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (widget.selecteds != null)
            ...widget.headers
                .map(
                  (header) => Expanded(
                      child: Container(
                    color: Colors.amber.withOpacity(0.75),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                      header.toString(),
                    ),
                  )),
                )
                .toList()
        ],
      ),
    );
  }

  List<Widget> desktopList() {
    // If no receipts, show no data widget
    if (widget.total == 0) {
      return [widget.noDataWidget];
    }

    // Otherwise map to desktop entries
    return widget.source!.map((e) {
      return DataEntryWidgetDesktop(
          isSelecting: widget.isSelecting,
          color: widget.prefferedColor,
          data: e,
          headers: widget.headers);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.reponseScreenSizes.isNotEmpty &&
            widget.reponseScreenSizes.contains(context.screenSize)
        ?

        /// for small screen
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// title and actions
              if (widget.title != null || widget.actions != null)
                Container(
                  // padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]!))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.title != null) widget.title!,
                      if (widget.actions != null) ...widget.actions!
                    ],
                  ),
                ),

              if (widget.autoHeight)
                Column(
                  children: [
                    //  if (widget.selecteds != null) mobileHeader(),
                    if (widget.isLoading) loadingIndicator,
                    ...mobileList(),
                  ],
                ),

              if (!widget.autoHeight)
                Expanded(
                  child: Column(
                    children: [
                      // if (widget.selecteds != null) mobileHeader(),
                      if (widget.isLoading) loadingIndicator,

                      /// mobileList
                      ...mobileList(),
                    ],
                  ),
                ),

              /// footer
              if (widget.footers != null)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [...widget.footers!],
                )
            ],
          )

        /**
          * for large screen
          */
        : Column(
            children: [
              //title and actions
              if (widget.title != null || widget.actions != null)
                Container(
                  // padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]!))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.title != null) widget.title!,
                      if (widget.actions != null) ...widget.actions!
                    ],
                  ),
                ),

              /// desktopHeader
              if (widget.headers.isNotEmpty) desktopHeader(),

              if (widget.isLoading) loadingIndicator,

              if (widget.autoHeight) Column(children: desktopList()),

              if (!widget.autoHeight)
                // desktopList
                if (widget.source != null && widget.source!.isNotEmpty)
                  Expanded(child: ListView(children: desktopList())),

              //footer
              if (widget.footers != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [...widget.footers!],
                )
            ],
          );
  }

  LinearProgressIndicator get loadingIndicator {
    return LinearProgressIndicator(
      backgroundColor: widget.prefferedColor.withOpacity(0.5),
      color: widget.prefferedColor,
    );
  }
}
