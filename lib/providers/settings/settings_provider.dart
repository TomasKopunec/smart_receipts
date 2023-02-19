import 'package:flutter/material.dart';
import 'package:smart_receipts/providers/settings/settings_dto.dart';
import 'package:smart_receipts/helpers/shared_preferences_helper.dart';
import 'package:smart_receipts/utils/logger.dart';

enum Currency {
  pound('British Pound', '£', 'gbp'),
  euro('British Dollar', '€', 'eur'),
  dollar('United States Dollar', '\$', 'usd'),
  australian_dollar('Australian Dollar', '\$', 'aud'),
  canadian_dollar('Canada Dollar', '\$', 'cad'),
  swiss_frank('Switzerland Franc', 'chf', 'chf'),
  hkd('Hong Kong Dollar', '\$', 'hkd');

  const Currency(this.name, this.currency, this.code);
  final String name;
  final String currency;
  final String code;

  static Currency from(String code) {
    return Currency.values
        .firstWhere((e) => e.code.toLowerCase() == code.toLowerCase());
  }

  String toJson() => code;
}

enum DateTimeFormat {
  standard('Standard Format', 'July 16, 2022', 'yMMMMd'),
  short('Short Format', '7/16/2022', 'yMd'),
  long('Long Format', '6:30 PM, July 16, 2022', 'K:m a, MMMM d, y');

  const DateTimeFormat(this.name, this.example, this.format);
  final String name;
  final String example;
  final String format;

  String getName() {
    return name;
  }

  static DateTimeFormat from(String name) {
    return DateTimeFormat.values
        .firstWhere((e) => e.getName().toLowerCase() == name.toLowerCase());
  }
}

enum ThemeSetting {
  light('Light'),
  dark('Dark');

  const ThemeSetting(this.name);
  final String name;

  static ThemeSetting from(String name) {
    return ThemeSetting.values
        .firstWhere((e) => e.name.toLowerCase() == name.toLowerCase());
  }
}

class SettingsProvider with ChangeNotifier {
  final Logger logger = Logger(SettingsProvider);

  Currency _selectedCurrency = Currency.pound;
  DateTimeFormat _selectedDateTimeFormat = DateTimeFormat.standard;
  ThemeSetting _selectedTheme = ThemeSetting.light;
  bool _digitalOnly = true;
  bool _staySignedIn = true;

  /// Settings loading
  bool loadSettingsFromDto(SettingsDto dto) {
    try {
      selectCurrency(Currency.from(dto.currency));
      selectDateTimeFormat(DateTimeFormat.from(dto.dateFormat));
      selectTheme(ThemeSetting.from(dto.theme));
      setDigitalOnly(dto.digitalOnly);
      setStaySignedIn(dto.staySignedIn);
      return true;
    } catch (e) {
      return false;
    }
  }

  SettingsDto getSettingsDto() {
    return SettingsDto(
      staySignedIn: _staySignedIn,
      currency: _selectedCurrency.code,
      dateFormat: _selectedDateTimeFormat.getName(),
      digitalOnly: _digitalOnly,
      theme: _selectedTheme.name,
    );
  }

  ///

  /// Upon every change in the settings, save into shared preferences
  void save() async {
    final result = await SharedPreferencesHelper.saveSettings(getSettingsDto());
    if (result) {
      logger.log("Settings saved.");
    }
  }

  /* Digital Only */
  bool get digitalOnly {
    return _digitalOnly;
  }

  void setDigitalOnly(bool val) {
    if (val != _digitalOnly) {
      _digitalOnly = val;
      save();
      notifyListeners();
    }
  }

  /* Currency */
  void selectCurrency(Currency currency) {
    _selectedCurrency = currency;
    save();
    notifyListeners();
  }

  Currency get currency {
    return _selectedCurrency;
  }

  /* Date Time */
  void selectDateTimeFormat(DateTimeFormat format) {
    if (format != _selectedDateTimeFormat) {
      _selectedDateTimeFormat = format;
      save();
      notifyListeners();
    }
  }

  DateTimeFormat get dateTimeFormat {
    return _selectedDateTimeFormat;
  }

  /* Theme */
  void selectTheme(ThemeSetting theme) {
    if (_selectedTheme != theme) {
      _selectedTheme = theme;
      save();
      notifyListeners();
    }
  }

  ThemeSetting get theme {
    return _selectedTheme;
  }

  /* Remember Me */
  void setStaySignedIn(bool staySignedIn) {
    if (staySignedIn != _staySignedIn) {
      _staySignedIn = staySignedIn;
      save();
      notifyListeners();
    }
  }

  void toggleRememberMe() {
    _staySignedIn = !_staySignedIn;
    save();
    notifyListeners();
  }

  bool get staySignedIn {
    return _staySignedIn;
  }
}
