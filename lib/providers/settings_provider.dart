import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Currency {
  pound('British Pound', '£', 'gbp'),
  euro('British Dollar', '€', 'eur'),
  dollar('United States Dollar', '\$', 'usd'),
  australian_dollar('Australian Dollar', '\$', 'aud'),
  canadian_dollar('Canada Dollar', '\$', 'cad'),
  swiss_frank('Switzerland Franc', 'chf', 'chf'),
  hkd('Hong Kong Dollar', '\$', 'hkd'),
  ;

  const Currency(this.name, this.currency, this.code);
  final String name;
  final String currency;
  final String code;
}

enum DateTimeFormat {
  standard('Standard Format', 'July 16, 2022', 'MMMMMMMMMM d, y'),
  short('Short Format', '7/16/2022', 'yMd'),
  long('Long Format', '6:30 PM, July 16, 2022', 'K:m a, MMMM d y');

  const DateTimeFormat(this.name, this.example, this.format);
  final String name;
  final String example;
  final String format;
}

class SettingsProvider with ChangeNotifier {
  Currency _selectedCurrency = Currency.pound;

  DateTimeFormat _selectedDateTimeFormat = DateTimeFormat.standard;

  bool _digitalOnly = true;

  bool get digitalOnly {
    return _digitalOnly;
  }

  void setDigitalOnly(bool val) {
    if (val != _digitalOnly) {
      _digitalOnly = val;
      notifyListeners();
    }
  }

  void selectCurrency(Currency currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  Currency get currency {
    return _selectedCurrency;
  }

  void selectDateTimeFormat(DateTimeFormat format) {
    _selectedDateTimeFormat = format;
    notifyListeners();
  }

  DateTimeFormat get dateTimeFormat {
    return _selectedDateTimeFormat;
  }
}
