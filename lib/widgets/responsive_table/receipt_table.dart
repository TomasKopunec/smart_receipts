import 'package:flutter/material.dart';
import 'package:http/http.dart';
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

  // int _currentPerPage = 10;
  // ReceiptAttribute _searchKey = ReceiptAttribute.purchaseDate;

  // int _currentPage = 1;

  bool _isLoading = false;

  late final ReceiptsProvider _receiptsProvider;

  @override
  void setState(func) {
    if (mounted) {
      super.setState(() {
        func();
      });
    }
  }

  /* Asynchronous operations */
  _checkForNewData() async {
    setState(() => _isLoading = true);

    final res = await () {};

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    // Initialise Receipts Provider
    _receiptsProvider = Provider.of<ReceiptsProvider>(context, listen: false);

    // At open, check if we have any more data
    _checkForNewData();

    // Reload state when receipts change
    _receiptsProvider.addListener(() => setState(() => {}));

    // Reset the screen everytime opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _receiptsProvider.resetSource();
    });

    super.initState();
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
        ? 'Sorry, we couldn\'t find any receipts that match your search criteria.'
        : 'No receipts have been received yet.';

    final subtitle = (_receiptsProvider.filterValue.isNotEmpty &&
            _receiptsProvider.receiptSize == 0)
        ? 'Please check the spelling or search for another receipt.'
        : 'Make a purchase and scan your personal QR code to receive a digital receipt during the next checkout.';

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
    if (_receiptsProvider.searchKey == ReceiptField.purchaseDateTime) {
      return GroupType.purchaseTime;
    } else if (_receiptsProvider.searchKey == ReceiptField.retailerName) {
      return GroupType.retailerName;
    } else if (_receiptsProvider.searchKey == ReceiptField.status) {
      return GroupType.status;
    } else if (_receiptsProvider.searchKey == ReceiptField.purchaseLocation) {
      return GroupType.location;
    } else {
      return GroupType.none;
    }
  }

  /// Footer
  // Row _getRowsPerPageSection() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       const Text('Rows per page:'),
  //       const SizedBox(width: 6),
  //       if (_perPages.isNotEmpty)
  //         DropdownButton<int>(
  //           borderRadius: BorderRadius.circular(8),
  //           iconEnabledColor: Theme.of(context).primaryColor,
  //           value: _currentPerPage,
  //           items: _perPages
  //               .map((e) => DropdownMenuItem<int>(
  //                     value: e,
  //                     child: Text('$e'),
  //                   ))
  //               .toList(),
  //           onChanged: (dynamic value) {
  //             setState(() {
  //               _currentPerPage = value;
  //               _currentPage = 1;
  //             });
  //           },
  //           isExpanded: false,
  //         )
  //     ],
  //   );
  // }

  // Row _getCurrentPageSection() {
  //   isFirstPage() {
  //     return _currentPage == 1;
  //   }

  //   isLastPage() {
  //     return _currentPage + _currentPerPage - 1 >=
  //         _receiptsProvider.receiptSize;
  //   }

  //   upperRange() {
  //     return _currentPage + _currentPerPage >= _receiptsProvider.receiptSize
  //         ? _receiptsProvider.receiptSize
  //         : _currentPage + _currentPerPage - 1;
  //   }

  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       Text(
  //           "$_currentPage - ${upperRange()} of ${_receiptsProvider.receiptSize}"),
  //       IconButton(
  //         icon: isFirstPage()
  //             ? _getIcon(Icons.arrow_back_ios_new_rounded, false)
  //             : _getIcon(Icons.arrow_back_ios_new_rounded, true),
  //         onPressed: isFirstPage()
  //             ? null
  //             : () {
  //                 var nextSet = _currentPage - _currentPerPage;
  //                 setState(() {
  //                   _currentPage = nextSet > 1 ? nextSet : 1;
  //                 });
  //               },
  //       ),
  //       IconButton(
  //         icon: isLastPage()
  //             ? _getIcon(Icons.arrow_forward_ios_rounded, false)
  //             : _getIcon(Icons.arrow_forward_ios_rounded, true),
  //         onPressed: isLastPage()
  //             ? null
  //             : () {
  //                 var nextSet = _currentPage + _currentPerPage;

  //                 setState(() {
  //                   _currentPage = nextSet < _receiptsProvider.receiptSize
  //                       ? nextSet
  //                       : _receiptsProvider.receiptSize - _currentPerPage;
  //                 });
  //               },
  //       )
  //     ],
  //   );
  // }

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
