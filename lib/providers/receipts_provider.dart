import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/models/receipt.dart';
import 'package:smart_receipts/utils/shared_preferences_helper.dart';

class ReceiptsProvider with ChangeNotifier {
  bool _isSelecting = false;

  final Set<String> _selecteds = {}; // List of receipts (uid)
  final Set<String> _favorites = {};

  List<Receipt> _receipts = [];

  List<Receipt> get receipts {
    return [..._receipts];
  }

  Receipt getReceiptByUid(String uid) {
    return _receipts.firstWhere((element) => element.uid.value == uid);
  }

  List<Map<String, dynamic>> get receiptsAsJson {
    return [..._receipts].map((receipt) {
      return receipt.asJson();
    }).toList();
  }

  List<Map<String, dynamic>> getFilteredReceipts(
      ReceiptAttribute searchKey, String value) {
    if (value.isEmpty) {
      return receiptsAsJson;
    }

    return receiptsAsJson
        .where((receipt) => receipt[searchKey.name]
            .toString()
            .toLowerCase()
            .contains(value.toString().toLowerCase()))
        .toList();
  }

  Future<dynamic> fetchAndSetReceipts() async {
    List<Receipt> newList = [];

    return Future.delayed(const Duration(milliseconds: 0)).then((value) {
      newList.addAll(_generateData(n: 8));
      _receipts = newList;
      notifyListeners();
    });
  }

  List<Receipt> _generateData({required int n}) {
    final List<Receipt> generated = [];
    for (int i = 1; i <= n; i++) {
      generated.add(Receipt(
          storeName: 'Store $i',
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
              .values[Random().nextInt(ReceiptStatus.values.length)]));
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

  void clearSelecteds({bool notify = false}) {
    _selecteds.clear();
    if (notify) {
      notifyListeners();
    }
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

  void flipFavorite(String uid) {
    if (_favorites.contains(uid)) {
      _favorites.remove(uid);
    } else {
      _favorites.add(uid);
    }

    SharedPreferencesHelper.saveFavorites(_favorites.toList()).then((value) {
      notifyListeners();
    });
  }

  void flipFavorites(List<String> list) {
    for (final uid in list) {
      flipFavorite(uid);
    }

    SharedPreferencesHelper.saveFavorites(_favorites.toList()).then((value) {
      notifyListeners();
    });
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
