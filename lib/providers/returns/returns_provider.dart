import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/helpers/requests/returns_request_helper.dart';
import 'package:smart_receipts/models/return/return.dart';
import '../../widgets/control_header/sorting_selection_dropdown.dart';

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

  void setSearchKey(ReturnField key) {
    if (key == _searchKey) {
      toggleSorting();
    }
    _searchKey = key;
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
