import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:smart_receipts/models/receipt.dart';

class ReceiptsProvider with ChangeNotifier {
  final List<Receipt> _receipts = [
    Receipt(
        storeName: 'Zara',
        amount: 79.99,
        purchaseDate: DateTime.now(),
        storeLocation: 'London, UK',
        category: 'Fashion',
        expiration: DateTime.now().add(Duration(days: 365)),
        sku: '123456',
        uid: '1111',
        status: ReceiptStatus.active),
    Receipt(
        storeName: 'H&M',
        amount: 29.99,
        purchaseDate: DateTime.now(),
        storeLocation: 'Bratislava, SK',
        category: 'Fashion',
        expiration: DateTime.now().add(Duration(days: 365 * 2)),
        sku: '456789',
        uid: '2222',
        status: ReceiptStatus.active),
    Receipt(
        storeName: 'Apple',
        amount: 499.99,
        purchaseDate: DateTime.now(),
        storeLocation: 'California, US',
        category: 'Electronics',
        expiration: DateTime.now().add(Duration(days: 365 * 3)),
        sku: '13579',
        uid: '3333',
        status: ReceiptStatus.active),
  ];

  List<Receipt> get receipts {
    return [..._receipts];
  }

  List<Map<String, dynamic>> get receiptsAsJson {
    return [..._receipts].map((receipt) {
      return receipt.asJson();
    }).toList();
  }

  /* Future<void> fetchAndSetProducts() async {
    List<Receipt> newList = [];

    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      newList.addAll(_generateData(n: 120));
      _receipts = newList;
      notifyListeners();

      _sourceOriginal.clear();
      _sourceOriginal.addAll(_generateData(n: 120)); // random.nextInt(1000)));
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered.getRange(0, _currentPerPage).toList();
      setState(() => _isLoading = false);
    });
  } */

  /*
  List<Receipt> _generateData({int n = 100}) {
    final List<Receipt> generated = [];
    for (int i = 0; i < n; i++) {
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
    return generated;
  }
  */
}
