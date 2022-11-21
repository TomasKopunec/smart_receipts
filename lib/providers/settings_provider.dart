import 'package:flutter/material.dart';

enum Currency {
  pound('£'),
  euro('€'),
  dollar('\$');

  const Currency(this.symbol);
  final String symbol;

  @override
  String toString() {
    return symbol;
  }

  static Currency from(String name) {
    return Currency.values.firstWhere((e) => name.contains(e.toString()));
  }
}

class SettingsProvider with ChangeNotifier {
  Currency selectedCurrency = Currency.pound;

  void selectCurrency(Currency currency) {
    selectedCurrency = currency;
    notifyListeners();
  }

  Currency get currency {
    return selectedCurrency;
  }
}
