import 'package:smart_receipts/models/return/returned_item.dart';

enum ReturnField {
  receiptId('Receipt ID'),
  recentDateTime('Most Recent Return'),
  refundedAmount('Refunded Amount'),
  returnedItems('Returned Items');

  final String colName;

  const ReturnField(this.colName);

  static ReturnField from(String name) {
    return ReturnField.values.firstWhere((e) => e.name == name.toLowerCase());
  }

  @override
  String toString() {
    return colName;
  }
}

class Return {
  final String receiptId;
  final String customerEmail;
  final DateTime recentDateTime;
  final double refundedAmount;
  final List<ReturnedItem> returnedItems;

  Return({
    required this.receiptId,
    required this.customerEmail,
    required this.recentDateTime,
    required this.refundedAmount,
    required this.returnedItems,
  });

  static Return fromJson(Map<String, dynamic> json) => Return(
      receiptId: json['receipt_id'],
      customerEmail: json['customer_email'],
      recentDateTime: DateTime.parse(json['recent_datetime']),
      refundedAmount: json['refunded_amount'],
      returnedItems: (json['returned_items'] as List<dynamic>)
          .map((e) => ReturnedItem.fromJson(e))
          .toList());

  Map<String, dynamic> toJson() => {
        'receipt_id': receiptId,
        'customer_email': customerEmail,
        'recent_datetime': recentDateTime.toIso8601String(),
        'refunded_amount': refundedAmount,
        'returned_items': returnedItems.map((e) => e.toJson()).toList()
      };

  static List<ReturnField> getSearchableKeys() {
    return [
      ReturnField.recentDateTime,
      ReturnField.refundedAmount,
    ];
  }

  int getProductsCount() {
    return returnedItems.length;
  }

  dynamic getField(ReturnField field) {
    switch (field) {
      case ReturnField.receiptId:
        return receiptId;
      case ReturnField.recentDateTime:
        return recentDateTime;
      case ReturnField.refundedAmount:
        return refundedAmount;
      case ReturnField.returnedItems:
        return returnedItems;
    }
  }
}
