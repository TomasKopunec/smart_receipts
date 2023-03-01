import 'package:smart_receipts/models/receipt/receipt.dart';

class ReceiptsFilterHelper {
  /// Filters out according to the Receipts provider
  /// 1. Favourites
  /// 2. Date Range
  /// 3. Criteria
  static Future<List<Receipt>> filterReceipts({
    required List<Receipt> receipts,
    required String value,
    Set<String>? favourites,
    required bool favEnabled,
    DateTime? start,
    DateTime? end,
  }) async {
    // 1. Filter favourites
    if (favourites != null && favEnabled) {
      receipts =
          await _filterReceiptFavourites(receipts, favourites, favEnabled);
      if (receipts.isEmpty) {
        return Future(() => []);
      }
    }

    // 2. Filter by Date Range
    if (start != null && end != null) {
      receipts = await _filterDateRange(receipts, start, end);
      if (receipts.isEmpty) {
        return Future(() => []);
      }
    }

    // 3. Filter by criteria
    receipts = await _filterReceiptCriteria(receipts, value);
    return receipts;
  }

  /// Filters out favourite receipts
  static Future<List<Receipt>> _filterReceiptFavourites(
      List<Receipt> receipts, Set<String> favourites, bool favEnabled) {
    return Future(() =>
        receipts.where((r) => _favourite(r, favourites, favEnabled)).toList());
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
            ReceiptsFilterHelper._retailerName(r, value) ||
            ReceiptsFilterHelper._purchaseLocation(r, value) ||
            ReceiptsFilterHelper._productNames(r, value) ||
            ReceiptsFilterHelper._productCategories(r, value) ||
            ReceiptsFilterHelper._price(r, double.tryParse(value)) ||
            ReceiptsFilterHelper._status(r, value) ||
            ReceiptsFilterHelper._receiptId(r, value))
        .toList());
  }

  static bool _dateRange(Receipt r, DateTime start, DateTime end) {
    final DateTime purchaseDateTime = r.purchaseDateTime;
    return purchaseDateTime.isAfter(start.subtract(const Duration(days: 1))) &&
        purchaseDateTime.isBefore(end.add(const Duration(days: 1)));
  }

  static bool _favourite(Receipt r, Set<String> favourites, bool favEnabled) {
    return favEnabled ? favourites.contains(r.receiptId) : true;
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
