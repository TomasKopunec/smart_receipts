import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/utils/shared_preferences_helper.dart';

import '../models/product/product.dart';
import '../widgets/receipt_dropdown_button.dart';

class ReceiptsProvider with ChangeNotifier {
  List<Receipt> _receipts = [];

  List<Map<String, dynamic>> _source = [];

  bool _isSelecting = false;

  final Set<int> _selecteds = {}; // List of selected receipts (id)
  final Set<int> _favorites = {}; // List of favorite receipts (id)

  int get receiptSize {
    return _receipts.length;
  }

  bool _isShowingFavorites = false;
  String _filterValue = '';
  ReceiptField _searchKey =
      ReceiptField.purchase_date_time; // Refer to Receipt class
  SortStatus _sortStatus = SortStatus.desc;

  void resetState() {
    _filterValue = '';
    _searchKey = ReceiptField.purchase_date_time;
    _sortStatus = SortStatus.desc;
    _selecteds.clear();
    _isSelecting = false;
    _isShowingFavorites = false;
    _updateSource();
  }

  // FAVOURITES
  void toggleFavourites() {
    _isShowingFavorites = !_isShowingFavorites;
    _updateSource();
  }

  bool get isShowingFavorites {
    return _isShowingFavorites;
  }

  // MAIN
  void setSource(List<Map<String, dynamic>> newSource) {
    _source = newSource;
    notifyListeners();
  }

  List<Map<String, dynamic>> get source {
    return _source;
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

  ReceiptField get searchKey {
    return _searchKey;
  }

  void setSearchKey(String key) {
    if (key == _searchKey.name) {
      toggleSorting();
    }
    _searchKey = ReceiptField.from(key);

    if (_searchKey == ReceiptField.status) {
      toggleSorting();
    }

    _updateSource();
  }

  // Other
  Receipt getReceiptById(int id) {
    return _receipts.firstWhere((e) => e.id == id);
  }

  void _updateSource() {
    List<Map<String, dynamic>> newSource = [];

    newSource = [..._receipts]
        // Change to JSON
        .map((receipt) => receipt.toJson())
        // Filter our favourites
        .where((receipt) {
          if (_isShowingFavorites) {
            return _favorites.contains(receipt['id']);
          } else {
            return true;
          }
        })
        // Filter according to search key
        .where((receipt) => receipt[_searchKey]
            .toString()
            .toLowerCase()
            .contains(_filterValue.toString().toLowerCase()))
        .toList();

    newSource.sort((a, b) {
      if (_sortStatus == SortStatus.asc) {
        return a[_searchKey.name].compareTo(b[_searchKey.name]);
      } else {
        return b[_searchKey.name].compareTo(a[_searchKey.name]);
      }
    });

    setSource(newSource);
  }

  Future<dynamic> fetchAndSetReceipts() async {
    List<Receipt> newList = [];

    return Future.delayed(const Duration(milliseconds: 250)).then((value) {
      newList.addAll(_generateData(n: 8));
      _receipts = newList;

      // Update source
      _updateSource();
    });
  }

  void selectAll() {
    for (var e in _receipts) {
      _selecteds.add(e.id);
    }
    notifyListeners();
  }

  void clearSelecteds({bool notify = false}) {
    _selecteds.clear();
    if (notify) {
      notifyListeners();
    }
  }

  List<Receipt> _generateData({required int n}) {
    List<String> storeNames = [
      'H&M',
      'Zara',
      'McDonald\'s',
      'Lidl',
      'Gant',
      'Nike',
      'Dell',
      'Deli Store'
    ];

    final List<Receipt> generated = [];
    for (int i = 1; i <= n; i++) {
      final List<Product> products = [];

      final numberOfProducts = Random().nextInt(40) + 1;
      for (int x = 0; x <= numberOfProducts; x++) {
        products.add(Product(
            id: x,
            name: 'Item $x',
            price: x * 10,
            sku: '$x',
            category: 'Default Category'));
      }

      generated.add(Receipt(
          id: i,
          auto_delete_date_time: DateTime.now().add(const Duration(days: 365)),
          retailer_receipt_id: i,
          retailer_id: i,
          retailer_name: storeNames[Random().nextInt(storeNames.length)],
          customer_id: i,
          purchase_date_time: DateTime.now()
              .subtract(Duration(days: Random().nextInt(365 * 2))),
          purchase_location: 'London, UK',
          status: ReceiptStatus
              .values[Random().nextInt(ReceiptStatus.values.length)],
          expiration: DateTime.now()
              .subtract(Duration(days: i))
              .add(const Duration(days: 365)),
          price: (Random().nextDouble() * 200),
          currency: 'GBP',
          paymentMethod: 'Card',
          cardNumber: "1234 1234 1234 1234",
          products: products));
    }
    generated.shuffle();
    return generated;
  }

  int get selectedsLen {
    return _selecteds.length;
  }

  void toggleSelecting() {
    _isSelecting = !_isSelecting;
    notifyListeners();
  }

  bool get isSelecting {
    return _isSelecting;
  }

  void addSelectedByID(int id) {
    _selecteds.add(id);
    notifyListeners();
  }

  void removeSelectedByID(int id) {
    _selecteds.remove(id);
    notifyListeners();
  }

  bool selectedContains(int id) {
    return _selecteds.contains(id);
  }

  List<int> get selecteds {
    return [..._selecteds];
  }

  List<int> get favorites {
    return [..._favorites];
  }

  void flipFavorite(int id, [bool notify = true]) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }

    SharedPreferencesHelper.saveFavorites(_favorites.toList());
    if (notify) {
      notifyListeners();
    }
  }

  void flipFavorites(List<int> list) {
    for (final id in list) {
      flipFavorite(id, false);
    }
    notifyListeners();
  }

  bool isFavorite(int id) {
    return _favorites.contains(id);
  }

  Future<Set<int>> fetchAndSetFavorites() async {
    final fetched = await SharedPreferencesHelper.getFavorites();
    _favorites.addAll(fetched);
    notifyListeners();
    return _favorites;
  }

  List<Receipt> getMostRecent([int n = 2]) {
    List<Receipt> copy = [..._receipts];
    copy.sort((a, b) => (a.getField(ReceiptField.purchase_date_time)
            as DateTime)
        .compareTo(b.getField(ReceiptField.purchase_date_time) as DateTime));
    return copy.take(n).toList();
  }
}
