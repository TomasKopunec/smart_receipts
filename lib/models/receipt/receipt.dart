import 'package:json_annotation/json_annotation.dart';
import '../product/product.dart';

part 'receipt.g.dart';

enum ReceiptStatus {
  active,
  expired,
  returned;

  static ReceiptStatus from(String name) {
    return ReceiptStatus.values.firstWhere((e) => e.name == name.toLowerCase());
  }
}

enum ReceiptField {
  id('ID'),
  retailer_name('Retailer Name'),
  purchase_date_time('Purchase Time'),
  purchase_location('Purchase Location'),
  status('Status'),
  expiration('Expiration'),
  price('Price'),
  currency('Currency'),
  payment('Payment'),
  products('Products');

  final String colName;

  const ReceiptField(this.colName);

  static ReceiptField from(String name) {
    return ReceiptField.values.firstWhere((e) => e.name == name.toLowerCase());
  }

  @override
  String toString() {
    return this.colName;
  }
}

@JsonSerializable()
class Receipt {
  final int id;
  final DateTime? auto_delete_date_time;
  final int retailer_receipt_id;
  final int retailer_id;
  final String retailer_name;
  final int customer_id;
  final DateTime purchase_date_time;
  final String purchase_location;
  final ReceiptStatus status;
  final DateTime? expiration;
  final double price;
  final String currency;
  final String payment;
  final List<Product> products;

  Receipt(
      {required this.id,
      required this.auto_delete_date_time,
      required this.retailer_receipt_id,
      required this.retailer_id,
      required this.retailer_name,
      required this.customer_id,
      required this.purchase_date_time,
      required this.purchase_location,
      required this.status,
      required this.expiration,
      required this.price,
      required this.currency,
      required this.payment,
      required this.products});

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptToJson(this);

  static List<ReceiptField> getSearchableKeys() {
    return [
      ReceiptField.id,
      ReceiptField.retailer_name,
      ReceiptField.purchase_date_time,
      ReceiptField.purchase_location,
      ReceiptField.price,
      ReceiptField.status
    ];
  }

  int getProductsCount() {
    return products.length;
  }

  dynamic getField(ReceiptField field) {
    switch (field) {
      case ReceiptField.id:
        return id;
      case ReceiptField.retailer_name:
        return retailer_name;
      case ReceiptField.purchase_date_time:
        return purchase_date_time;
      case ReceiptField.purchase_location:
        return purchase_location;
      case ReceiptField.status:
        return status;
      case ReceiptField.expiration:
        return expiration;
      case ReceiptField.price:
        return price;
      case ReceiptField.currency:
        return currency;
      case ReceiptField.payment:
        return payment;
      case ReceiptField.products:
        return products;
      default:
        throw Exception('Undefined ${field.toString()}');
    }
  }
}
