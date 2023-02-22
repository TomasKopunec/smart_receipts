import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/helpers/requests/returns_request_helper.dart';
import 'package:smart_receipts/helpers/returns_filter_helper.dart';
import 'package:smart_receipts/models/return/return.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import '../../widgets/control_header/sorting_selection_dropdown.dart';

class ReturnsProvider with ChangeNotifier {
  ReceiptsProvider? receipts;

  List<Return> _returns = [];
  List<Return> _source = [];

  String _filterValue = '';

  ReturnField _searchKey = ReturnField.recentDateTime; // Refer to Return class

  SortStatus _sortStatus = SortStatus.desc;

  final ReturnsRequestHelper _returnsRequestHelper = ReturnsRequestHelper();

  DateTime _start = DateTime(DateTime.now().year);
  DateTime _end = DateTime.now();

  /// Set the Receipts
  Future<dynamic> setReturns(List<Return> returns) async {
    _returns = returns;
    _updateSource();
  }

  Future<void> fetchAndSetReturns(String token) async {
    final response = await _returnsRequestHelper.getReturns(token);
    setReturns(response.status ? response.returns! : []);
  }

  /// Update Source
  void _updateSource() async {
    // We can't have any returns if we have no receipts
    if (receipts == null || receipts!.receiptSize == 0) {
      return;
    }

    // 1. If original receipt has not been set yet, add it
    for (var r in _returns) {
      r.originalReceipt ??= receipts!.getReceiptById(r.receiptId);
    }

    // 2. Create new source
    List<Return> newReturns = await ReturnsFilterHelper.filterReturns(
      returns: [..._returns],
      value: _filterValue,
      start: _start,
      end: _end,
    );

    newReturns.sort((a, b) {
      if (_sortStatus == SortStatus.asc) {
        return a.getField(_searchKey).compareTo(b.getField(_searchKey));
      } else {
        return b.getField(_searchKey).compareTo(a.getField(_searchKey));
      }
    });

    // Finally update the source
    _source = newReturns;
    notifyListeners();
  }

  List<Return> get source {
    return [..._source];
  }

  int get returnsSize {
    return _returns.length;
  }

  void setSearchKey(ReturnField key) {
    if (key == _searchKey) {
      toggleSorting();
    }
    _searchKey = key;

    _updateSource();
  }

  Return getReturnById(String id) {
    return _returns.firstWhere((e) => e.receiptId == id);
  }

  ReturnField get searchKey {
    return _searchKey;
  }

  // SORTING
  SortStatus get sortStatus {
    return _sortStatus;
  }

  void toggleSorting() {
    _sortStatus =
        _sortStatus == SortStatus.asc ? SortStatus.desc : SortStatus.asc;
    _updateSource();
  }

  // FILTERING
  String get filterValue {
    return _filterValue;
  }

  void setFilterValue(value) {
    _filterValue = value.trim();
    _updateSource();
  }

  // RESET
  void resetSource() {
    _filterValue = '';
    _searchKey = ReturnField.recentDateTime;
    _sortStatus = SortStatus.desc;
    _start = DateTime(DateTime.now().year);
    _end = DateTime.now();
    _updateSource();
  }

  // DATE RANGE
  DateTime get startRangeDate {
    return _start;
  }

  DateTime get endRangeDate {
    return _end;
  }

  void setStartRangeDate(DateTime start) {
    _start = start;
    _updateSource();
  }

  void setEndRangeDate(DateTime end) {
    _end = end;
    _updateSource();
  }
}
