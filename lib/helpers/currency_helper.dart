import '../providers/settings/settings_provider.dart';

class CurrencyHelper {
  static String getFormatted(
      {required double price,
      required Currency originCurrency,
      required Currency targetCurrency}) {
    String priceFormatted =
        convert(price, originCurrency, targetCurrency).toStringAsFixed(2);

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
        case Currency.australian_dollar:
          return price * 1.75;
        case Currency.canadian_dollar:
          return price * 1.62;
        case Currency.swiss_frank:
          return price * 1.11;
        case Currency.hkd:
          return price * 9.45;
      }
    }

    return price;
  }
}
