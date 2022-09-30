import 'package:adaptivex/adaptivex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/providers/nav_bar_provider.dart';
import 'package:smart_receipts/utils/snackbar_builder.dart';
import 'package:smart_receipts/widgets/animated_dropdown_button.dart';
import 'package:smart_receipts/widgets/no_data_found_widget.dart';
import 'package:smart_receipts/widgets/selection_app_bar.dart';
import 'package:smart_receipts/widgets/table/responsive_table/datatable_wrapper.dart';
import '../animated/animated_toggle_switch.dart';
import '../search_bar.dart';
import 'responsive_table/datatable_header.dart';
import 'responsive_table/datatable.dart';

class ReceiptTable extends StatefulWidget {
  final Color headerColor;

  const ReceiptTable({super.key, required this.headerColor});

  @override
  State<ReceiptTable> createState() => _ReceiptTableState();
}

class _ReceiptTableState extends State<ReceiptTable> {
  bool _isSelecting = false;

  String _filterValue = '';

  late List<DatatableHeader> _headers; // Will be set in initState

  final List<int> _perPages = [10, 20, 50, 100];

  int _total = 100;
  int _currentPerPage = 10;
  late List<bool> _expanded;
  ReceiptAttribute _searchKey = ReceiptAttribute.purchase_date;

  int _currentPage = 1;

  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _selecteds = [];

  // String? _sortColumn;
  // bool _sortAscending = true;

  bool _isLoading = true;

  _fetchData() async {
    setState(() => _isLoading = true);

    Provider.of<ReceiptsProvider>(context, listen: false)
        .fetchAndSetReceipts()
        .then((value) => setState(() => _isLoading = false));
  }

  _filterData(value) {
    // Start loading
    // setState(() => _isLoading = true);

    final data = Provider.of<ReceiptsProvider>(context, listen: false)
        .getFilteredReceipts(_searchKey, value);
    _updateTableFilter(value, data);

    setState(() {});
    // Finish loading
    // setState(() => _isLoading = false);
  }

  _sortData(String value, SortStatus sortStatus) {
    setState(() => _isLoading = true);

    final receiptAttribute = ReceiptAttribute.from(value);

    // Sort
    _sourceFiltered.sort((a, b) {
      return b[receiptAttribute.name].compareTo(a[receiptAttribute.name]);
    });

    // Reverse according to ASC/DESC
    _sourceFiltered = sortStatus == SortStatus.asc
        ? _sourceFiltered.reversed.toList()
        : _sourceFiltered;

    var rangeTop = _currentPerPage < _sourceFiltered.length
        ? _currentPerPage
        : _sourceFiltered.length;

    // Update source
    _source = _sourceFiltered.getRange(0, rangeTop).toList();

    // Change the search key
    _searchKey = receiptAttribute;

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    /// Initialize headers
    _headers = ReceiptAttribute.values
        .map((attr) => DatatableHeader(
            text: attr.toString(),
            value: attr.name,
            show: true,
            sortable: true,
            textAlign: TextAlign.left,
            editable: false))
        .toList();

    _fetchData();

    _updateExpanded();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateTableFilter(
      String searchValue, List<Map<String, dynamic>> newSource) {
    _filterValue = searchValue;

    _total = newSource.length;
    _sourceFiltered = newSource;

    // Get the upper range
    final upperRange = _sourceFiltered.length < _currentPerPage
        ? _sourceFiltered.length
        : _currentPerPage;

    _source = _sourceFiltered.getRange(0, upperRange).toList();

    // Expanded
    _updateExpanded();
  }

  void _updateTable({required List<Map<String, dynamic>> receipts}) {
    // Update the total
    _total = receipts.length;

    // Get the upper range
    final upperRange =
        receipts.length < _currentPerPage ? receipts.length : _currentPerPage;

    // Update the filtered source
    _sourceFiltered = receipts;

    // Update the source
    _source = receipts.getRange(0, upperRange).toList();

    // Update expanded
    _updateExpanded();
  }

  int _updateExpanded({int start = 0}) {
    var expandedLen =
        _total - start < _currentPerPage ? _total - start : _currentPerPage;
    _expanded = List.generate(expandedLen, (index) => false);
    return expandedLen;
  }

  void _updateTableFooter({int start = 0}) {
    setState(() {
      final int expandedLen = _updateExpanded(start: start);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + expandedLen).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Add listener that rebuilds the list whenever the receipts get changed, resetting all filters and everything
    final provider = Provider.of<ReceiptsProvider>(context, listen: true);
    provider.addListener(() {
      // Refresh the table and clear the filter
      _filterValue = '';
      _updateTable(receipts: provider.receiptsAsJson);
    });

    final title = (_filterValue.isNotEmpty && _total == 0)
        ? 'Sorry, we couldn\'t find this item in any of your receipts.'
        : 'Sorry, we couldn\'t find any receipts.';

    final subtitle = (_filterValue.isNotEmpty && _total == 0)
        ? 'Please check the spelling or search for another receipt.'
        : 'Please check your internet connection or add your first receipt.';

    return DatatableWrapper(
        color: widget.headerColor,
        table: ResponsiveDatatable(
          isSelecting: _isSelecting,
          noDataWidget: NoDataFoundWidget(
              color: widget.headerColor,
              height: SizeHelper.getScreenHeight(context) * 0.5,
              title: title,
              subtitle: subtitle),
          prefferedColor: widget.headerColor,
          reponseScreenSizes: const [ScreenSize.xs],
          title: null,
          total: _total,
          actions: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.receipt, color: widget.headerColor),
                        Text(
                          'All receipts',
                          style: TextStyle(
                              color: widget.headerColor,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeHelper.getFontSize(context,
                                  size: FontSize.regular)),
                        ),
                        TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  widget.headerColor.withOpacity(0.2)),
                            ),
                            onPressed: () {
                              if (_total == 0 || _source == null) {
                                AppSnackBar.show(
                                    context,
                                    AppSnackBarBuilder()
                                        .withText('No receipts available.')
                                        .withDuration(Duration(seconds: 3)));
                                return;
                              }

                              // final receiptsProvider =
                              //     Provider.of<ReceiptsProvider>(context,
                              //         listen: false);

                              final uiProvider = Provider.of<NavBarProvider>(
                                  context,
                                  listen: false);

                              setState(() {
                                _isSelecting = !_isSelecting;

                                if (_isSelecting) {
                                  uiProvider.setAppBar(SelectionAppBar(
                                    selecting: _isSelecting,
                                    color: widget.headerColor,
                                  ));
                                } else {
                                  uiProvider.clearAppBar();
                                }

                                /* if (_isSelecting) {
                                  Scaffold.of(context).showBottomSheet(
                                      (ctx) => ModalSheet(
                                            color: widget.headerColor
                                                .withOpacity(0.95),
                                            delete: () {
                                              print(
                                                  'Deleting receipts with following ids: ${provider.selecteds}');
                                            },
                                            star: () {
                                              print(
                                                  'Starring receipts with following ids: ${provider.selecteds}');
                                            },
                                          ),
                                      enableDrag: false);
                                } else {
                                  Provider.of<ReceiptsProvider>(context,
                                          listen: false)
                                      .clearSelecteds();
                                  Navigator.of(context).pop();
                                } */
                              });
                            },
                            child: Text(
                              _isSelecting ? 'Cancel' : 'Select',
                              style: TextStyle(color: widget.headerColor),
                            ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    SearchBar(
                      searchKey: _searchKey.toString(),
                      color: widget.headerColor,
                      filter: _filterData,
                    ),
                    const SizedBox(height: 10),
                    AnimatedToggleSwitch(
                      width: SizeHelper.getScreenWidth(context),
                      animDuration: const Duration(milliseconds: 750),
                      values: const ['ALL', 'STARRED'],
                      onToggleCallback: (value) {
                        print(value);
                      },
                      buttonColor: widget.headerColor,
                      backgroundColor: Colors.black.withOpacity(0.1),
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SORT BY:',
                              style: TextStyle(
                                  color: widget.headerColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeHelper.getFontSize(context,
                                      size: FontSize.regular)),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            AnimatedDropdownButton(
                                sortBy: _sortData,
                                width: SizeHelper.getScreenWidth(context) * 0.4,
                                color: widget.headerColor,
                                items: ReceiptAttribute.values,
                                selected: _searchKey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            // Expanded(child: SearchBar(color: widget.headerColor)),
          ],
          headers: _headers,
          source: _source,
          selecteds: _selecteds,
          autoHeight: true,
          // onChangedRow: (value, header) {
          //   print(value);
          //   print(header);
          // },
          // onSubmittedRow: (value, header) {
          //   print(value);
          //   print(header);
          // },
          // onTabRow: (data) {
          //   print(data);
          // },
          // onSort: (value) => _sortData(value),
          expanded: _expanded,
          // sortAscending: _sortAscending,
          // sortColumn: _sortColumn,
          isLoading: _isLoading,
          onSelect: (value, item) {
            if (value!) {
              setState(() {
                _selecteds.add(item);
                print('Selected ${item.toString()}');
              });
            } else {
              setState(() {
                _selecteds.removeAt(_selecteds.indexOf(item));
                print('Un-Selected ${item.toString()}');
              });
            }
          },
          onSelectAll: (value) {
            if (value!) {
              setState(() {
                _selecteds = [..._sourceFiltered];
              });
              print('Selecting all receipts: ${_selecteds.length}');
            } else {
              setState(() {
                _selecteds.clear();
              });
              print('Un-selecting all receipts: ${_selecteds.length}');
            }
          },
          footers: _getFooters(),
        ));
  }

  /// Footer
  Row _getRowsPerPageSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('Rows per page:'),
        if (_perPages.isNotEmpty)
          DropdownButton<int>(
            borderRadius: BorderRadius.circular(8),
            iconEnabledColor: widget.headerColor,
            value: _currentPerPage,
            items: _perPages
                .map((e) => DropdownMenuItem<int>(
                      value: e,
                      child: Text('$e'),
                    ))
                .toList(),
            onChanged: (dynamic value) {
              setState(() {
                _currentPerPage = value;
                _currentPage = 1;
                _updateTableFooter();
              });
            },
            isExpanded: false,
          )
      ],
    );
  }

  Row _getCurrentPageSection() {
    isFirstPage() {
      return _currentPage == 1;
    }

    isLastPage() {
      return _currentPage + _currentPerPage - 1 >= _total;
    }

    upperRange() {
      return _currentPage + _currentPerPage >= _total
          ? _total
          : _currentPage + _currentPerPage - 1;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("$_currentPage - ${upperRange()} of $_total"),
        IconButton(
          icon: isFirstPage()
              ? _getIcon(Icons.arrow_back_ios_new_rounded, false)
              : _getIcon(Icons.arrow_back_ios_new_rounded, true),
          onPressed: isFirstPage()
              ? null
              : () {
                  var nextSet = _currentPage - _currentPerPage;
                  setState(() {
                    _currentPage = nextSet > 1 ? nextSet : 1;
                    _updateTableFooter(start: _currentPage - 1);
                  });
                },
        ),
        IconButton(
          icon: isLastPage()
              ? _getIcon(Icons.arrow_forward_ios_rounded, false)
              : _getIcon(Icons.arrow_forward_ios_rounded, true),
          onPressed: isLastPage()
              ? null
              : () {
                  var nextSet = _currentPage + _currentPerPage;

                  setState(() {
                    _currentPage =
                        nextSet < _total ? nextSet : _total - _currentPerPage;
                    _updateTableFooter(start: _currentPage - 1);
                  });
                },
        )
      ],
    );
  }

  List<Widget> _getFooters() {
    return [
      _getRowsPerPageSection(),
      _getCurrentPageSection(),
    ];
  }

  /// Helper methods
  Icon _getIcon(IconData icon, bool isActive, {double? size}) {
    return Icon(
      icon,
      color:
          isActive ? widget.headerColor : widget.headerColor.withOpacity(0.5),
      size: size,
    );
  }
}
