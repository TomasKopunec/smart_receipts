import '../providers/settings/settings_provider.dart';

class CurrencyHelper {
  static String getFormatted({
    required double price,
    required Currency originCurrency,
    required Currency targetCurrency,
    bool includeCurrency = true,
  }) {
    String priceFormatted =
        convert(price, originCurrency, targetCurrency).toStringAsFixed(2);

    if (!includeCurrency) {
      return priceFormatted;
    }

    return targetCurrency == Currency.pound
        ? '${targetCurrency.currency.toUpperCase()}$priceFormatted'
        : '$priceFormatted${targetCurrency.currency.toUpperCase()}';
  }

  static double convert(
      double price, Currency originCurrency, Currency targetCurrency) {
    if (originCurrency == Currency.pound) {
      switch (targetCurrency) {
        case Currency.pound:
          return price;
        case Currency.euro:
          return price * 1.12;
        case Currency.dollar:
          return price * 1.2;
        case Currency.australianDollar:
          return price * 1.75;
        case Currency.canadianDollar:
          return price * 1.62;
        case Currency.swissFrank:
          return price * 1.11;
        case Currency.hkd:
          return price * 9.45;
      }
    }

    return price;
  }
}
