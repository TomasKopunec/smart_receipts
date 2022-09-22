import 'package:adaptivex/adaptivex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/widgets/table/responsive_table/datatable_wrapper.dart';

import 'responsive_table/datatable_header.dart';
import 'responsive_table/datatable.dart';
import 'search_bar.dart';

class ReceiptTable extends StatefulWidget {
  final Color headerColor;

  const ReceiptTable({required this.headerColor});

  @override
  State<ReceiptTable> createState() => _ReceiptTableState();
}

class _ReceiptTableState extends State<ReceiptTable> {
  String _filterValue = '';

  late List<DatatableHeader> _headers; // Will be set in initState

  final List<int> _perPages = [10, 20, 50, 100];

  int _total = 100;
  int _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "uid";

  int _currentPage = 1;

  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _selecteds = [];

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;

  _fetchData() async {
    setState(() => _isLoading = true);

    Provider.of<ReceiptsProvider>(context, listen: false)
        .fetchAndSetReceipts()
        .then((value) => setState(() => _isLoading = false));
  }

  _filterData(value) {
    // Start loading
    setState(() => _isLoading = true);
    _filterValue = value;

    // Update filtered receipts
    _sourceFiltered = Provider.of<ReceiptsProvider>(context, listen: false)
        .getFilteredReceipts(_searchKey!, _filterValue);

    // Finish loading
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateTableFooter({int start = 0}) {
    setState(() {
      var expandedLen =
          _total - start < _currentPerPage ? _total - start : _currentPerPage;
      _expanded = List.generate(expandedLen, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + expandedLen).toList();
    });
  }

  void _updateTable(List<Map<String, dynamic>>? receipts) {
    // Ignore other rebuild if the receipts passed are false
    if (receipts == null || receipts.isEmpty) {
      return;
    }

    // Update if we are filtering
    if (_filterValue.isEmpty) {
      _sourceFiltered = receipts;

      final upperRange =
          receipts.length < _currentPerPage ? receipts.length : _currentPerPage;

      _source = _sourceFiltered.getRange(0, upperRange).toList();
    } else {
      var rangeTop = _total < _currentPerPage ? _total : _currentPerPage;
      _expanded = List.generate(rangeTop, (index) => false);
    }

    _total = _sourceFiltered.length;

    // setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Add listener that rebuilds the list whenever the receipts get changed, resetting all filters and everything
    final provider = Provider.of<ReceiptsProvider>(context, listen: true);
    provider.addListener(() => _updateTable(provider.receiptsAsJson));

    return DatatableWrapper(
        color: widget.headerColor,
        table: ResponsiveDatatable(
          prefferedColor: widget.headerColor,
          reponseScreenSizes: const [ScreenSize.xs],
          title: _getTitle(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
              child: SearchBar(
                  searchKey: _searchKey!,
                  width: SizeHelper.getScreenWidth(context) * 0.5,
                  color: widget.headerColor,
                  filter: _filterData,
                  searchIcon: Icons.search),
            )
          ],
          headers: _headers,
          source: _source,
          selecteds: _selecteds,
          showSelect: true,
          autoHeight: true,
          onChangedRow: (value, header) {
            /// print(value);
            /// print(header);
          },
          onSubmittedRow: (value, header) {
            /// print(value);
            /// print(header);
          },
          onTabRow: (data) {
            print(data);
          },
          onSort: (value) {
            setState(() => _isLoading = true);

            setState(() {
              _sortColumn = value;
              _sortAscending = !_sortAscending;
              if (_sortAscending) {
                _sourceFiltered.sort(
                    (a, b) => b["$_sortColumn"].compareTo(a["$_sortColumn"]));
              } else {
                _sourceFiltered.sort(
                    (a, b) => a["$_sortColumn"].compareTo(b["$_sortColumn"]));
              }
              var rangeTop = _currentPerPage < _sourceFiltered.length
                  ? _currentPerPage
                  : _sourceFiltered.length;
              // _source = _sourceFiltered.getRange(0, rangeTop).toList();
              _searchKey = value;

              _isLoading = false;
            });
          },
          expanded: _expanded,
          sortAscending: _sortAscending,
          sortColumn: _sortColumn,
          isLoading: _isLoading,
          onSelect: (value, item) {
            print("$value  $item ");
            if (value!) {
              setState(() => _selecteds.add(item));
            } else {
              setState(() => _selecteds.removeAt(_selecteds.indexOf(item)));
            }
          },
          onSelectAll: (value) {
            if (value!) {
              setState(() => _selecteds =
                  _sourceFiltered.map((entry) => entry).toList().cast());
            } else {
              setState(() => _selecteds.clear());
            }
          },
          footers: _getFooters(),
        ));
  }

  /// Header
  Widget _getTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: TextButton.icon(
        onPressed: () => {
          // Do something
        },
        icon: _getIcon(Icons.add, true),
        label: Text(
          "Add receipt",
          style: TextStyle(color: widget.headerColor),
        ),
      ),
    );
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
                      child: Text("$e"),
                      value: e,
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
    _isFirstPage() {
      return _currentPage == 1;
    }

    _isLastPage() {
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
          icon: _isFirstPage()
              ? _getIcon(Icons.arrow_back_ios_new_rounded, false)
              : _getIcon(Icons.arrow_back_ios_new_rounded, true),
          onPressed: _isFirstPage()
              ? null
              : () {
                  var _nextSet = _currentPage - _currentPerPage;
                  setState(() {
                    _currentPage = _nextSet > 1 ? _nextSet : 1;
                    _updateTableFooter(start: _currentPage - 1);
                  });
                },
        ),
        IconButton(
          icon: _isLastPage()
              ? _getIcon(Icons.arrow_forward_ios_rounded, false)
              : _getIcon(Icons.arrow_forward_ios_rounded, true),
          onPressed: _isLastPage()
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
