import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

enum ProductField {
  id('ID'),
  name('name'),
  price('price'),
  sku('sku'),
  category('category');

  final String colName;

  const ProductField(this.colName);

  static ProductField from(String name) {
    return ProductField.values.firstWhere((e) => e.name == name.toLowerCase());
  }

  @override
  String toString() {
    return this.colName;
  }
}

@JsonSerializable()
class Product {
  final int id;
  final String name;
  final double price;
  final String sku;
  final String category;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.sku,
      required this.category});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  dynamic getField(ProductField field) {
    switch (field) {
      case ProductField.id:
        return id;
      case ProductField.name:
        return name;
      case ProductField.price:
        return price;
      case ProductField.sku:
        return sku;
      case ProductField.category:
        return category;
      default:
        throw Exception('Undefined key in Product! "${field.toString}"');
    }
  }

  static List<ProductField> getVisibleKeys() {
    return [
      ProductField.name,
      ProductField.price,
      ProductField.sku,
      ProductField.category
    ];
  }
}
