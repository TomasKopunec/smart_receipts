import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/color_helper.dart';

import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/widgets/no_data_found_widget.dart';
import 'package:smart_receipts/widgets/responsive_table/datatable.dart';

class ReceiptTable extends StatefulWidget {
  final Color headerColor = ColorHelper.APP_COLOR;

  @override
  State<ReceiptTable> createState() => _ReceiptTableState();
}

class _ReceiptTableState extends State<ReceiptTable> {
  final List<int> _perPages = [10, 20, 50, 100];

  int _currentPerPage = 10;
  // ReceiptAttribute _searchKey = ReceiptAttribute.purchaseDate;

  int _currentPage = 1;
  bool _isLoading = false;

  late ReceiptsProvider _receiptsProvider;

  @override
  void setState(func) {
    if (mounted) {
      super.setState(() {
        func();
      });
    }
  }

  /* Asynchronous operations */
  _fetchData() async {
    setState(() => _isLoading = true);
    _receiptsProvider.fetchAndSetReceipts().then((value) {
      setState(() => _isLoading = false);
    });
  }

  _setItems() async {
    setState(() => _isLoading = true);
    Future.delayed(
      const Duration(seconds: 1),
      () {},
    ).then((value) {
      setState(() => _isLoading = false);
    });
  }

  @override
  void initState() {
    _receiptsProvider = Provider.of<ReceiptsProvider>(context, listen: false);

    // Check if we have receipts already fetched
    // if (_receiptsProvider.receiptSize == 0) {
    //   _fetchData();
    // }

    // _updateExpanded();

    super.initState();

    _receiptsProvider.addListener(() {
      setState(() {
        // Ignore
      });
    });

    // Reset the screen everytime opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _receiptsProvider.resetState();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*
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

    // Filter and sort according to the current selection
    // _sortData();
    // _filterData(_filterValue);

    // Update expanded
    _updateExpanded();
  }
  
  */

  void _updateTableFooter({int start = 0}) {
    setState(() {
      // final int expandedLen = _updateExpanded(start: start);
      // _source.clear();
      // _source = _sourceFiltered.getRange(start, start + expandedLen).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuilding receipt table!');

    final title = (_receiptsProvider.filterValue.isNotEmpty &&
            _receiptsProvider.receiptSize == 0)
        ? 'Sorry, we couldn\'t find this item in any of your receipts.'
        : 'Sorry, we couldn\'t find any receipts.';

    final subtitle = (_receiptsProvider.filterValue.isNotEmpty &&
            _receiptsProvider.receiptSize == 0)
        ? 'Please check the spelling or search for another receipt.'
        : 'Please check your internet connection or add your first receipt.';

    bool isSortingByDate =
        _receiptsProvider.searchKey == ReceiptAttribute.expiration ||
            _receiptsProvider.searchKey == ReceiptAttribute.purchaseDate;

    return ResponsiveDatatable(
      isSortingByDate: isSortingByDate,
      isSelecting: _receiptsProvider.isSelecting,
      noDataWidget: NoDataFoundWidget(
          color: widget.headerColor,
          height: SizeHelper.getScreenHeight(context) * 0.5,
          title: title,
          subtitle: subtitle),
      prefferedColor: widget.headerColor,
      total: _receiptsProvider.receiptSize,
      headers: ReceiptAttribute.values,
      source: _receiptsProvider.source,
    );
  }

  /// Footer
  Row _getRowsPerPageSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('Rows per page:'),
        const SizedBox(width: 6),
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
      return _currentPage + _currentPerPage - 1 >=
          _receiptsProvider.receiptSize;
    }

    upperRange() {
      return _currentPage + _currentPerPage >= _receiptsProvider.receiptSize
          ? _receiptsProvider.receiptSize
          : _currentPage + _currentPerPage - 1;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
            "$_currentPage - ${upperRange()} of ${_receiptsProvider.receiptSize}"),
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
                    _currentPage = nextSet < _receiptsProvider.receiptSize
                        ? nextSet
                        : _receiptsProvider.receiptSize - _currentPerPage;
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

  LinearProgressIndicator get loadingIndicator {
    return LinearProgressIndicator(
      backgroundColor: widget.headerColor.withOpacity(0.5),
      color: widget.headerColor,
    );
  }
}
