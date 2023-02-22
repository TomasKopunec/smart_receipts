import 'package:smart_receipts/helpers/receipts_filter_helper.dart';
import 'package:smart_receipts/models/return/return.dart';

class ReturnsFilterHelper {
  /// Filters out according to the Returns provider
  /// 1. Date Range
  /// 2. Receipt criteria search
  static Future<List<Return>> filterReturns({
    required List<Return> returns,
    required String value,
    required DateTime start,
    required DateTime end,
  }) async {
    // 1. Filter by Date Range
    returns = await _filterDateRange(returns, start, end);
    if (returns.isEmpty) {
      return Future(() => []);
    }

    // 2. Perform receipts search (on returns original receipts)
    final receipts = await ReceiptsFilterHelper.filterReceipts(
      receipts: returns.map((e) => e.originalReceipt!).toList(),
      value: value,
    );
    final receiptIds = receipts.map((r) => r.receiptId).toSet();

    // 3. Return all returns that have a matching ID with found receipts
    return returns.where((r) => receiptIds.contains(r.receiptId)).toList();
  }

  /// Filters by Date Range
  static Future<List<Return>> _filterDateRange(
      List<Return> returns, DateTime start, DateTime end) {
    return Future(
        () => returns.where((r) => _dateRange(r, start, end)).toList());
  }

  static bool _dateRange(Return r, DateTime start, DateTime end) {
    // Find earliest return
    DateTime earliest = DateTime.now().add(const Duration(days: 1));
    for (final item in r.returnedItems) {
      if (item.returnDateTime.isBefore(earliest)) {
        earliest = item.returnDateTime;
      }
    }
    final DateTime latest = r.recentDateTime;
    return earliest.isAfter(start) && latest.isBefore(end);
  }
}
