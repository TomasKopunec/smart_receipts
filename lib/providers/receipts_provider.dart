import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:smart_receipts/models/receipt.dart';

class ReceiptsProvider with ChangeNotifier {
  List<Receipt> _receipts = [];

  List<Receipt> get receipts {
    return [..._receipts];
  }

  List<Map<String, dynamic>> get receiptsAsJson {
    return [..._receipts].map((receipt) {
      return receipt.asJson();
    }).toList();
  }

  List<Map<String, dynamic>> getFilteredReceipts(
      String searchKey, String value) {
    if (value.isEmpty) {
      return receiptsAsJson;
    }

    return receiptsAsJson
        .where((receipt) => receipt[searchKey]
            .toString()
            .toLowerCase()
            .contains(value.toString().toLowerCase()))
        .toList();
  }

  Future<dynamic> fetchAndSetReceipts() async {
    List<Receipt> newList = [];

    return Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      newList.addAll(_generateData(n: 60));
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
          purchaseDate: DateTime.now().subtract(Duration(days: i)),
          storeLocation: 'London, UK',
          category: 'Fashion',
          expiration: DateTime.now()
              .subtract(Duration(days: i))
              .add(const Duration(days: 365)),
          sku: '$i\000$i',
          uid: '$i',
          status: ReceiptStatus.active));
    }
    generated.shuffle();
    return generated;
  }
}
