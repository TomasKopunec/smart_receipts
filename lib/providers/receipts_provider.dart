import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/models/receipt.dart';
import 'package:smart_receipts/utils/shared_preferences_helper.dart';

import '../models/product.dart';
import '../screens/tabs/all_receipts/animated_dropdown_button.dart';

class ReceiptsProvider with ChangeNotifier {
  List<Receipt> _receipts = [];

  List<Map<String, dynamic>> _source = [];

  bool _isSelecting = false;

  final Set<String> _selecteds = {}; // List of selected receipts (uid)
  final Set<String> _favorites = {}; // List of favorite receipts (uid)

  int get receiptSize {
    return _receipts.length;
  }

  bool _isShowingFavorites = false;
  String _filterValue = '';
  ReceiptAttribute _searchKey = ReceiptAttribute.purchaseDate;
  SortStatus _sortStatus = SortStatus.desc;

  void resetState() {
    _filterValue = '';
    _searchKey = ReceiptAttribute.purchaseDate;
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

  ReceiptAttribute get searchKey {
    return _searchKey;
  }

  void setSearchKey(ReceiptAttribute key) {
    if (key == _searchKey) {
      toggleSorting();
    }
    _searchKey = key;
    _updateSource();
  }

  // Other
  Receipt getReceiptByUid(String uid) {
    return _receipts.firstWhere((element) => element.uid.value == uid);
  }

  void _updateSource() {
    List<Map<String, dynamic>> newSource = [];

    newSource = [..._receipts]
        .map((e) => e.asJson()) // Change to JSON
        .where((e) {
          // Filter our favourites
          if (_isShowingFavorites) {
            return _favorites.contains(e[ReceiptAttribute.uid.name]);
          } else {
            return true;
          }
        })
        .where((e) => e[_searchKey.name] // Filter according to search value
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
      _selecteds.add(e.uid.value);
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
      final List<Product> items = [];
      for (int x = 1; x <= Random().nextInt(10); x++) {
        items.add(Product(itemName: 'Item $x'));
      }

      generated.add(
        Receipt(
            storeName: storeNames[Random().nextInt(storeNames.length)],
            amount: (i * 10.00) - 0.01,
            purchaseDate: DateTime.now()
                .subtract(Duration(days: Random().nextInt(2 * 365))),
            storeLocation: 'London, UK',
            category: 'Fashion',
            expiration: DateTime.now()
                .subtract(Duration(days: i))
                .add(const Duration(days: 365)),
            sku: '${i}000$i',
            uid: '$i',
            status: ReceiptStatus
                .values[Random().nextInt(ReceiptStatus.values.length)],
            items: items),
      );
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

  void addSelectedByUID(String uid) {
    _selecteds.add(uid);
    notifyListeners();
  }

  void removeSelectedByUID(String uid) {
    _selecteds.remove(uid);
    notifyListeners();
  }

  bool selectedContains(String uid) {
    return _selecteds.contains(uid);
  }

  List<String> get selecteds {
    return [..._selecteds];
  }

  List<String> get favorites {
    return [..._favorites];
  }

  void flipFavorite(String uid, [bool notify = true]) {
    if (_favorites.contains(uid)) {
      _favorites.remove(uid);
    } else {
      _favorites.add(uid);
    }

    SharedPreferencesHelper.saveFavorites(_favorites.toList());
    if (notify) {
      notifyListeners();
    }
  }

  void flipFavorites(List<String> list) {
    for (final uid in list) {
      flipFavorite(uid, false);
    }
    notifyListeners();
  }

  bool isFavorite(String uid) {
    return _favorites.contains(uid);
  }

  void fetchAndSetFavorites() async {
    final fetched = await SharedPreferencesHelper.getFavorites();

    if (fetched == null) {
      return;
    }

    _favorites.addAll(fetched);

    print('Successfully fetched favorites: $_favorites');

    notifyListeners();
  }
}
