import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/helpers/requests/returns_request_helper.dart';
import 'package:smart_receipts/models/return/return.dart';

import '../../widgets/receipt_dropdown_button.dart';

class ReturnsProvider with ChangeNotifier {
  List<Return> _returns = [];

  String _filterValue = '';

  ReturnField _searchKey = ReturnField.recentDateTime; // Refer to Return class

  SortStatus _sortStatus = SortStatus.desc;

  final ReturnsRequestHelper _returnsRequestHelper = ReturnsRequestHelper();

  /// Set the Receipts
  Future<dynamic> setReturns(List<Return> returns) async {
    _returns = returns;
  }

  Future<void> fetchAndSetReturns(String token) async {
    final response = await _returnsRequestHelper.getReturns(token);
    setReturns(response.status ? response.returns! : []);
  }

  List<Return> get returns {
    return [..._returns];
  }

  int get returnsSize {
    return _returns.length;
  }

  void setSearchKey(String key) {
    if (key == _searchKey.name) {
      toggleSorting();
    }
    _searchKey = ReturnField.from(key);
  }

  Return getReturnById(String id) {
    return _returns.firstWhere((e) => e.receiptId == id);
  }

  // SORTING
  SortStatus get sortStatus {
    return _sortStatus;
  }

  void toggleSorting() {
    _sortStatus =
        _sortStatus == SortStatus.asc ? SortStatus.desc : SortStatus.asc;
    notifyListeners();
  }

  // FILTERING
  String get filterValue {
    return _filterValue;
  }

  void setFilterValue(value) {
    _filterValue = value.trim();
    notifyListeners();
  }
}
