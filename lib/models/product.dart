import 'package:smart_receipts/models/json_attribute.dart';

enum ProductAttribute {
  name('Product Name');

  const ProductAttribute(this.colName);
  final String colName;

  @override
  String toString() {
    return colName;
  }

  static ProductAttribute from(String name) {
    return ProductAttribute.values.firstWhere((e) => e.name == name);
  }
}

class Product {
  final JsonAttribute itemName;

  Product({required String itemName})
      : itemName = JsonAttribute(ProductAttribute.name.name, itemName);

  Map<String, dynamic> asJson() {
    return {itemName.attribute: itemName.value};
  }
}
