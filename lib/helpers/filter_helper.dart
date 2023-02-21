import 'package:smart_receipts/models/receipt/receipt.dart';

class FilterHelper {
  /// Filters out according to the Receipts provider
  /// 1. Favourites
  /// 2. Date Range
  /// 3. Criteria
  static Future<List<Receipt>> filterReceipts({
    required List<Receipt> receipts,
    required String value,
    required Set<String> favourites,
    required bool favouritesEnabled,
    required DateTime start,
    required DateTime end,
  }) async {
    // 1. Filter favourites
    receipts =
        await _filterReceiptFavourites(receipts, favourites, favouritesEnabled);
    if (receipts.isEmpty) {
      return Future(() => []);
    }

    // 2. Filter by Date Range
    receipts = await _filterDateRange(receipts, start, end);
    if (receipts.isEmpty) {
      return Future(() => []);
    }

    // 3. Filter by criteria
    receipts = await _filterReceiptCriteria(receipts, value);
    return receipts;
  }

  /// Filters out favourite receipts
  static Future<List<Receipt>> _filterReceiptFavourites(
      List<Receipt> receipts, Set<String> favourites, bool favouritesEnabled) {
    return Future(() => receipts
        .where((r) => _favourite(r, favourites, favouritesEnabled))
        .toList());
  }

  /// Filters by Date Range
  static Future<List<Receipt>> _filterDateRange(
      List<Receipt> receipts, DateTime start, DateTime end) {
    return Future(
        () => receipts.where((r) => _dateRange(r, start, end)).toList());
  }

  /// Filters according to the following criteria:
  /// 1. Retailer name
  /// 2. Purchase location
  /// 3. Receipt products' names
  /// 4. Receipt products' categories
  /// 6. Price (round to nearest INT and compare if equal)
  /// 7. Status
  /// 8. Receipt ID
  /// Returns a Future (computationally expensive operation)
  static Future<List<Receipt>> _filterReceiptCriteria(
      List<Receipt> receipts, String value) {
    value = value.trim().toLowerCase();

    return Future(() => receipts
        .where((r) =>
            FilterHelper._retailerName(r, value) ||
            FilterHelper._purchaseLocation(r, value) ||
            FilterHelper._productNames(r, value) ||
            FilterHelper._productCategories(r, value) ||
            FilterHelper._price(r, double.tryParse(value)) ||
            FilterHelper._status(r, value) ||
            FilterHelper._receiptId(r, value))
        .toList());
  }

  static bool _dateRange(Receipt r, DateTime start, DateTime end) {
    final DateTime purchaseDateTime = r.purchaseDateTime;
    return purchaseDateTime.isAfter(start) && purchaseDateTime.isBefore(end);
  }

  static bool _favourite(Receipt r, Set<String> favourites, bool enabled) {
    return !enabled ? true : favourites.contains(r.receiptId);
  }

  static bool _retailerName(Receipt r, String value) =>
      r.retailerName.toLowerCase().contains(value);

  static bool _purchaseLocation(Receipt r, String value) =>
      r.purchaseLocation.toLowerCase().contains(value);

  static bool _productNames(Receipt r, String value) => r.products
      .map((p) => p.name.toLowerCase())
      .toList()
      .map((name) => name.contains(value))
      .reduce((a, b) => a || b);

  static bool _productCategories(Receipt r, String value) => r.products
      .map((p) => p.category.toLowerCase())
      .toList()
      .map((name) => name.contains(value))
      .reduce((a, b) => a || b);

  static bool _price(Receipt r, double? parsed) =>
      parsed == null ? false : r.price.round() == parsed.round();

  static bool _status(Receipt r, String value) =>
      r.status.name.toLowerCase().contains(value);

  static bool _receiptId(Receipt r, String value) =>
      r.receiptId.contains(value);
}
