import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/helpers/requests/returns_request_helper.dart';
import 'package:smart_receipts/models/return/return.dart';
import '../../widgets/control_header/sorting_selection_dropdown.dart';

class ReturnsProvider with ChangeNotifier {
  List<Return> _returns = [];
  List<Return> _source = [];

  String _filterValue = '';

  ReturnField _searchKey = ReturnField.recentDateTime; // Refer to Return class

  SortStatus _sortStatus = SortStatus.desc;

  final ReturnsRequestHelper _returnsRequestHelper = ReturnsRequestHelper();

  /// Set the Receipts
  Future<dynamic> setReturns(List<Return> returns) async {
    _returns = returns;
    _updateSource();
  }

  Future<void> fetchAndSetReturns(String token) async {
    final response = await _returnsRequestHelper.getReturns(token);
    setReturns(response.status ? response.returns! : []);
  }

  void _updateSource() {
    _source = [..._returns];

    // Filter acording to filter value
    _source = _source
        .where((e) => e
            .getField(searchKey)
            .toString()
            .toLowerCase()
            .contains(_filterValue.toUpperCase().toLowerCase()))
        .toList();

    // Sort according to search key
    _source.sort((a, b) {
      if (_sortStatus == SortStatus.asc) {
        return a.getField(_searchKey).compareTo(b.getField(_searchKey));
      } else {
        return b.getField(_searchKey).compareTo(a.getField(_searchKey));
      }
    });

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
}
