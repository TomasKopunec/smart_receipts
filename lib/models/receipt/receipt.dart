import 'package:flutter/material.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import '../product/product.dart';

enum ReceiptStatus {
  active(Colors.teal, "Active"),
  expired(Color.fromRGBO(227, 70, 73, 1), "Expired"),
  partial_return(Color.fromRGBO(135, 100, 151, 1), "Partially Returned"),
  returned(Color.fromRGBO(102, 96, 103, 1), "Returned");

  final Color color;
  final String title;

  const ReceiptStatus(this.color, this.title);

  static ReceiptStatus from(String name) {
    return ReceiptStatus.values
        .firstWhere((e) => e.name.toLowerCase() == name.toLowerCase());
  }

  String toJson() => name.toLowerCase();
}
/*
  20-21. March 52 pounds, GTW - Stockholm 13:00 - 16:30, 17:55 - 19:30
  18-20. April 58 pounds, VIE - ARN 18:00 - 20:15, 17:30 - 19:45

*/

enum ReceiptField {
  receiptId('Receipt ID'),
  retailerName('Retailer Name'),
  purchaseDateTime('Purchase Time'),
  purchaseLocation('Purchase Location'),
  status('Status'),
  expiration('Expiration'),
  price('Price'),
  currency('Currency'),
  paymentMethod('Payment Type'),
  cardNumber('Card Number'),
  products('Products');

  final String colName;

  const ReceiptField(this.colName);

  static ReceiptField from(String name) {
    return ReceiptField.values.firstWhere((e) => e.name == name.toLowerCase());
  }

  @override
  String toString() {
    return colName;
  }
}

class Receipt {
  final String receiptId;
  final String retailerReceiptId;
  final String retailerId;
  final String retailerName;
  final String customerEmail;
  final DateTime purchaseDateTime;
  final String purchaseLocation;
  final ReceiptStatus status;
  final DateTime? expiration;
  final double price;
  final Currency currency;
  final String paymentMethod;
  final String? cardNumber;

  final List<Product> products;

  Receipt({
    required this.receiptId,
    required this.retailerReceiptId,
    required this.retailerId,
    required this.retailerName,
    required this.customerEmail,
    required this.purchaseDateTime,
    required this.purchaseLocation,
    required this.status,
    required this.expiration,
    required this.price,
    required this.currency,
    required this.paymentMethod,
    this.cardNumber,
    required this.products,
  });

  static Receipt fromJson(Map<String, dynamic> json) => Receipt(
        receiptId: json['receiptId'] as String,
        retailerReceiptId: json['retailerReceiptId'] as String,
        retailerId: json['retailerId'] as String,
        retailerName: json['retailerName'] as String,
        customerEmail: json['customerEmail'] as String,
        purchaseDateTime: DateTime.parse(json['purchaseDateTime'] as String),
        purchaseLocation: json['purchaseLocation'] as String,
        status: ReceiptStatus.from(json['status']),
        expiration: json['expiration'] == null
            ? null
            : DateTime.parse(json['expiration'] as String),
        price: (json['price'] as num).toDouble(),
        currency: Currency.from(json['currency'] as String),
        paymentMethod: json['paymentMethod'] as String,
        cardNumber: json['cardNumber'] as String,
        products: (json['products'] as List<dynamic>)
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'receiptId': receiptId,
        'retailerReceiptId': retailerReceiptId,
        'retailerId': retailerId,
        'retailerName': retailerName,
        'customerEmail': customerEmail,
        'purchaseDateTime': purchaseDateTime.toIso8601String(),
        'purchaseLocation': purchaseLocation,
        'status': status.toJson(),
        'expiration': expiration?.toIso8601String(),
        'price': price,
        'currency': currency.toJson(),
        'paymentMethod': paymentMethod,
        'cardNumber': cardNumber,
        'products': products,
      };

  static List<ReceiptField> getSearchableKeys() {
    return [
      ReceiptField.receiptId,
      ReceiptField.retailerName,
      ReceiptField.purchaseDateTime,
      ReceiptField.purchaseLocation,
      ReceiptField.price,
      ReceiptField.status
    ];
  }

  Product findProductBySku(String sku) {
    return products.firstWhere((e) => e.sku == sku);
  }

  int getProductsCount() {
    return products.length;
  }

  dynamic getField(ReceiptField field) {
    switch (field) {
      case ReceiptField.receiptId:
        return receiptId;
      case ReceiptField.retailerName:
        return retailerName;
      case ReceiptField.purchaseDateTime:
        return purchaseDateTime;
      case ReceiptField.purchaseLocation:
        return purchaseLocation;
      case ReceiptField.status:
        return status;
      case ReceiptField.expiration:
        return expiration;
      case ReceiptField.price:
        return price;
      case ReceiptField.currency:
        return currency;
      case ReceiptField.paymentMethod:
        return paymentMethod;
      case ReceiptField.cardNumber:
        return cardNumber;
      case ReceiptField.products:
        return products;
      default:
        throw Exception('Undefined ${field.toString()}');
    }
  }
}
