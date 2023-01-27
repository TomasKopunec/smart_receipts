import '../providers/settings/settings_provider.dart';

class CurrencyHelper {
  static String getFormatted(double price, Currency currency) {
    String priceFormatted = price.toStringAsFixed(2);

    // TODO Convert according to rates

    return currency == Currency.pound
        ? '${currency.currency.toUpperCase()}$priceFormatted'
        : '$priceFormatted${currency.currency.toUpperCase()}';
  }
}
