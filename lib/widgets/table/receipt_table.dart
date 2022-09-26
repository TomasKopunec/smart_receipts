import 'package:adaptivex/adaptivex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/widgets/table/animated/animated_toggle_switch.dart';
import 'package:smart_receipts/widgets/table/responsive_table/datatable_wrapper.dart';
import 'package:smart_receipts/widgets/table/search_bar.dart';
import 'responsive_table/datatable_header.dart';
import 'responsive_table/datatable.dart';

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

    final data = Provider.of<ReceiptsProvider>(context, listen: false)
        .getFilteredReceipts(_searchKey!, value);
    _updateTableFilter(value, data);

    // Finish loading
    setState(() => _isLoading = false);
  }

  _sortData(value) {
    setState(() => _isLoading = true);

    final receiptAttribute = ReceiptAttribute.from(value);

    _sortColumn = value;

    // Flip the ascending property
    _sortAscending = !_sortAscending;

    // Sort
    _sourceFiltered.sort((a, b) {
      return b[receiptAttribute.name].compareTo(a[receiptAttribute.name]);
    });

    _sourceFiltered =
        _sortAscending ? _sourceFiltered : _sourceFiltered.reversed.toList();

    var rangeTop = _currentPerPage < _sourceFiltered.length
        ? _currentPerPage
        : _sourceFiltered.length;

    // Update source
    _source = _sourceFiltered.getRange(0, rangeTop).toList();

    // Change the search key
    _searchKey = value;

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

  @override
  Widget build(BuildContext context) {
    // Add listener that rebuilds the list whenever the receipts get changed, resetting all filters and everything
    final provider = Provider.of<ReceiptsProvider>(context, listen: true);
    provider.addListener(() {
      // Refresh the table and clear the filter
      _filterValue = '';
      _updateTable(receipts: provider.receiptsAsJson);
    });

    return DatatableWrapper(
        color: widget.headerColor,
        table: ResponsiveDatatable(
          prefferedColor: widget.headerColor,
          reponseScreenSizes: const [ScreenSize.xs],
          title: null,
          total: _total,
          actions: [
            /*SearchBar(
                searchKey: _searchKey!,
                width: SizeHelper.getScreenWidth(context) * 0.5,
                color: widget.headerColor,
                filter: _filterData, // Function
                searchIcon: Icons.search) */
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  children: [
                    Text('All receipts'),
                    const SizedBox(height: 10),
                    SearchBar(color: widget.headerColor),
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
                    )
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
          onSort: (value) => _sortData(value),
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
              setState(() {
                _selecteds = [..._sourceFiltered];
                print('Selecting all receipts: ${_selecteds.length}');
              });
            } else {
              setState(() {
                _selecteds.clear();
                print('Un-selecting all receipts: ${_selecteds.length}');
              });
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
