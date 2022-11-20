import 'package:smart_receipts/models/json_attribute.dart';

enum ReceiptStatus {
  active,
  expired,
  returned;

  static ReceiptStatus from(String name) {
    return ReceiptStatus.values.firstWhere((e) => e.name == name.toLowerCase());
  }
}

enum ReceiptAttribute {
  storeName('Store Name'),
  amount('Amount'),
  purchaseDate('Purchase Date'),
  storeLocation('Location'),
  category('Category'),
  expiration('Expiration'),
  sku('SKU'),
  uid('UID'),
  status('Status');

  const ReceiptAttribute(this.colName);
  final String colName;

  @override
  String toString() {
    return colName;
  }

  static ReceiptAttribute from(String name) {
    return ReceiptAttribute.values.firstWhere((e) => e.name == name);
  }
}

class Receipt {
  final JsonAttribute storeName;
  final JsonAttribute amount;
  final JsonAttribute purchaseDate;
  final JsonAttribute storeLocation;
  final JsonAttribute category;
  final JsonAttribute expiration;
  final JsonAttribute sku;
  final JsonAttribute uid;
  final JsonAttribute status;

  Receipt(
      {required String storeName,
      required double amount,
      required DateTime purchaseDate,
      required String storeLocation,
      required String category,
      required DateTime expiration,
      required String sku,
      required String uid,
      required ReceiptStatus status})
      : storeName = JsonAttribute(ReceiptAttribute.storeName.name, storeName),
        amount = JsonAttribute(ReceiptAttribute.amount.name, amount),
        purchaseDate = JsonAttribute(
            ReceiptAttribute.purchaseDate.name, purchaseDate.toIso8601String()),
        storeLocation =
            JsonAttribute(ReceiptAttribute.storeLocation.name, storeLocation),
        category = JsonAttribute(ReceiptAttribute.category.name, category),
        expiration = JsonAttribute(
            ReceiptAttribute.expiration.name, expiration.toIso8601String()),
        sku = JsonAttribute(ReceiptAttribute.sku.name, sku),
        uid = JsonAttribute(ReceiptAttribute.uid.name, uid),
        status = JsonAttribute(ReceiptAttribute.status.name, status);

  Map<String, dynamic> asJson() {
    return {
      storeName.attribute: storeName.value,
      amount.attribute: amount.value,
      purchaseDate.attribute: purchaseDate.value,
      storeLocation.attribute: storeLocation.value,
      category.attribute: category.value,
      expiration.attribute: expiration.value,
      sku.attribute: sku.value,
      uid.attribute: uid.value,
      status.attribute: (status.value as ReceiptStatus).name.toUpperCase(),
    };
  }
}
