import 'package:adaptivex/adaptivex.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_receipts/models/receipt.dart';
import 'package:smart_receipts/widgets/table/receipt_status_label.dart';
import 'package:smart_receipts/widgets/table/responsive_table/data_entry_widget.dart';
import 'datatable_header.dart';

class ResponsiveDatatable extends StatefulWidget {
  final Widget noDataWidget;
  final List<DatatableHeader> headers;
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
  final bool hideUnderline;
  final bool commonMobileView;
  final bool isExpandRows;
  final List<bool> expanded;
  final Widget Function(Map<String, dynamic> value)? dropContainer;
  final Function(Map<String, dynamic> value, DatatableHeader header)?
      onChangedRow;
  final Function(Map<String, dynamic> value, DatatableHeader header)?
      onSubmittedRow;
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
      this.onChangedRow,
      this.onSubmittedRow,
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

  Widget mobileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
          activeColor: widget.prefferedColor,
          value: areAllSelected,
          onChanged: (value) {
            if (widget.onSelectAll != null) {
              widget.onSelectAll!(value);
            }
          },
        ),
        PopupMenuButton(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          tooltip: "SORT BY",
          initialValue: widget.sortColumn,
          itemBuilder: (_) {
            List<PopupMenuEntry> widgets = [];
            for (final header in widget.headers) {
              if (header.show == true && header.sortable == true) {
                widgets.add(PopupMenuItem(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  height: 0,
                  value: header.value,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.sortColumn != null &&
                            widget.sortColumn == header.value)
                          widget.sortAscending!
                              ? Icon(Icons.arrow_downward,
                                  color: widget.prefferedColor)
                              : Icon(Icons.arrow_upward,
                                  color: widget.prefferedColor),
                        // const SizedBox(width: 10),
                        Text(
                          header.text,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ));
                widgets.add(const PopupMenuDivider());
              }
            }

            return widgets;
          },
          onSelected: (dynamic value) {
            if (widget.onSort != null) widget.onSort!(value);
          },
          child: Container(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
                child: Text(
              "SORT BY",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: widget.prefferedColor),
            )),
          ),
        ),
      ],
    );
  }

  List<Widget> mobileList() {
    if (widget.total == 0) {
      return [widget.noDataWidget];
    }

    const BorderRadius _radius = BorderRadius.all(Radius.circular(8));

    final _decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: _radius,
      boxShadow: [
        BoxShadow(
            color: widget.prefferedColor.withOpacity(0.3),
            blurRadius: 1.5,
            offset: const Offset(0, 2.5)),
      ],
    );

    final List<Widget> list = [];

    for (var i = 0; i < widget.source!.length; i++) {
      final data = widget.source!.elementAt(i);

      list.add(DataEntryWidget(
          selected: widget.selecteds!.contains(data),
          color: widget.prefferedColor,
          data: data,
          headers: widget.headers,
          commonMobileView: widget.commonMobileView,
          dropContainer: widget.dropContainer,
          onSelected: (value) {
            if (widget.onSelect != null) {
              widget.onSelect!(value, data);
            }
          }));
    }
    return list;
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

    return Column(
      children: [
        const Divider(thickness: 0.75),
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
                      onChanged: widget.onChangedRow,
                      onSubmitted: widget.onSubmittedRow,
                      hideUnderline: widget.hideUnderline,
                    )
                  : Text(stringOutput)
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
    final _headerDecoration = BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)));
    return Container(
      /// TODO:
      decoration: _headerDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.selecteds != null)
            Checkbox(
                activeColor: widget.prefferedColor,
                value: areAllSelected,
                onChanged: (value) {
                  if (widget.onSelectAll != null) widget.onSelectAll!(value);
                }),
          ...widget.headers
              .where((header) => header.show == true)
              .map(
                (header) => Expanded(
                    flex: header.flex,
                    child: InkWell(
                      onTap: () {
                        if (widget.onSort != null && header.sortable) {
                          widget.onSort!(header.value);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(11),
                        alignment: headerAlignSwitch(header.textAlign),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              header.text,
                              textAlign: header.textAlign,
                              // style: ,
                            ),
                            if (widget.sortColumn != null &&
                                widget.sortColumn == header.value)
                              widget.sortAscending!
                                  ? const Icon(Icons.arrow_downward, size: 15)
                                  : const Icon(Icons.arrow_upward, size: 15)
                          ],
                        ),
                      ),
                    )),
              )
              .toList()
        ],
      ),
    );
  }

  List<Widget> desktopList() {
    if (widget.total == 0) {
      return [widget.noDataWidget];
    }

    final _decoration = BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)));
    //  final _rowDecoration = widget.rowDecoration ?? _decoration;
    //  final _selectedDecoration = widget.selectedDecoration ?? _decoration;
    List<Widget> widgets = [];
    for (var index = 0; index < widget.source!.length; index++) {
      final data = widget.source![index];
      widgets.add(Column(
        children: [
          InkWell(
            onTap: () {
              widget.onTabRow?.call(data);
              setState(() {
                widget.expanded[index] = !widget.expanded[index];
              });
            },
            child: Container(
              padding: const EdgeInsets.all(0),

              /// TODO:
              decoration: _decoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.selecteds != null)
                    Row(
                      children: [
                        Checkbox(
                            activeColor: widget.prefferedColor,
                            value: widget.selecteds!.contains(data),
                            onChanged: (value) {
                              if (widget.onSelect != null) {
                                widget.onSelect!(value, data);
                              }
                            }),
                      ],
                    ),
                  ...widget.headers
                      .where((header) => header.show == true)
                      .map(
                        (header) => Expanded(
                          flex: header.flex,
                          child: header.editable
                              ? TextEditableWidget(
                                  data: data,
                                  header: header,
                                  textAlign: header.textAlign,
                                  onChanged: widget.onChangedRow,
                                  onSubmitted: widget.onSubmittedRow,
                                  hideUnderline: widget.hideUnderline,
                                )
                              : Text(
                                  "${data[header.value]}",
                                  textAlign: header.textAlign,
                                  // style:
                                ),
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          ),
          if (widget.isExpandRows &&
              widget.expanded![index] &&
              widget.dropContainer != null)
            widget.dropContainer!(data)
        ],
      ));
    }
    return widgets;
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
                Container(
                  child: Column(
                    children: [
                      if (widget.selecteds != null) mobileHeader(),
                      if (widget.isLoading) loadingIndicator,
                      ...mobileList(),
                    ],
                  ),
                ),

              if (!widget.autoHeight)
                Expanded(
                  child: Column(
                    children: [
                      if (widget.selecteds != null) mobileHeader(),
                      if (widget.isLoading) loadingIndicator,

                      /// mobileList
                      ...mobileList(),
                    ],
                  ),
                ),

              /// footer
              if (widget.footers != null)
                Container(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [...widget.footers!],
                  ),
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

class TextEditableWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  final DatatableHeader header;

  final TextAlign textAlign;

  final bool hideUnderline;

  final Function(Map<String, dynamic> vaue, DatatableHeader header)? onChanged;

  final Function(Map<String, dynamic> vaue, DatatableHeader header)?
      onSubmitted;

  const TextEditableWidget({
    Key? key,
    required this.data,
    required this.header,
    this.textAlign = TextAlign.center,
    this.hideUnderline = false,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          border: hideUnderline
              ? InputBorder.none
              : const UnderlineInputBorder(borderSide: BorderSide(width: 1)),
          alignLabelWithHint: true,
        ),
        textAlign: textAlign,
        controller: TextEditingController.fromValue(
          TextEditingValue(text: "${data[header.value]}"),
        ),
        onChanged: (newValue) {
          data[header.value] = newValue;
          onChanged?.call(data, header);
        },
        onSubmitted: (x) => onSubmitted?.call(data, header),
      ),
    );
  }
}
