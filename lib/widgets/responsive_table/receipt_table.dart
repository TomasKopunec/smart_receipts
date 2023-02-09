import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/widgets/no_data_found_widget.dart';
import 'package:smart_receipts/widgets/responsive_table/datatable.dart';

import '../../models/receipt/receipt.dart';

class ReceiptTable extends StatefulWidget {
  // final Color headerColor = ColorHelper.APP_COLOR;

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
    if (_receiptsProvider.receiptSize == 0) {
      _fetchData();
    }

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

  @override
  Widget build(BuildContext context) {
    final Color headerColor = Theme.of(context).primaryColor;

    print('Rebuilding receipt table!');

    final title = (_receiptsProvider.filterValue.isNotEmpty &&
            _receiptsProvider.receiptSize == 0)
        ? 'Sorry, we couldn\'t find this item in any of your receipts.'
        : 'Sorry, we couldn\'t find any receipts.';

    final subtitle = (_receiptsProvider.filterValue.isNotEmpty &&
            _receiptsProvider.receiptSize == 0)
        ? 'Please check the spelling or search for another receipt.'
        : 'Please check your internet connection or add your first receipt.';

    return ResponsiveDatatable(
      groupType: groupType,
      isSelecting: _receiptsProvider.isSelecting,
      noDataWidget: NoDataFoundWidget(
          color: headerColor,
          height: SizeHelper.getScreenHeight(context) * 0.5,
          title: title,
          subtitle: subtitle),
      prefferedColor: headerColor,
      total: _receiptsProvider.receiptSize,
      headers: Receipt.getSearchableKeys(),
      source: _receiptsProvider.source,
    );
  }

  GroupType get groupType {
    if (_receiptsProvider.searchKey == ReceiptField.purchase_date_time) {
      return GroupType.purchaseTime;
    } else if (_receiptsProvider.searchKey == ReceiptField.retailer_name) {
      return GroupType.retailerName;
    } else if (_receiptsProvider.searchKey == ReceiptField.status) {
      return GroupType.status;
    } else if (_receiptsProvider.searchKey == ReceiptField.purchase_location) {
      return GroupType.location;
    } else {
      return GroupType.none;
    }
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
            iconEnabledColor: Theme.of(context).primaryColor,
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
                  });
                },
        )
      ],
    );
  }

  /// Helper methods
  Icon _getIcon(IconData icon, bool isActive, {double? size}) {
    return Icon(
      icon,
      color: isActive
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColor.withOpacity(0.5),
      size: size,
    );
  }

  LinearProgressIndicator get loadingIndicator {
    return LinearProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
      color: Theme.of(context).primaryColor,
    );
  }
}
