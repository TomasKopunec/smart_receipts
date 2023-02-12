// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) => Receipt(
      receiptId: json['receiptId'] as String,
      retailerReceiptId: json['retailerReceiptId'] as String,
      retailerId: json['retailerId'] as String,
      retailerName: json['retailerName'] as String,
      customerEmail: json['customerEmail'] as String,
      purchaseDateTime: DateTime.parse(json['purchaseDateTime'] as String),
      purchaseLocation: json['purchaseLocation'] as String,
      status: $enumDecode(_$ReceiptStatusEnumMap, json['status']),
      expiration: json['expiration'] == null
          ? null
          : DateTime.parse(json['expiration'] as String),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethod: json['paymentMethod'] as String,
      cardNumber: json['cardNumber'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'receiptId': instance.receiptId,
      'retailerReceiptId': instance.retailerReceiptId,
      'retailerId': instance.retailerId,
      'retailerName': instance.retailerName,
      'customerEmail': instance.customerEmail,
      'purchaseDateTime': instance.purchaseDateTime.toIso8601String(),
      'purchaseLocation': instance.purchaseLocation,
      'status': _$ReceiptStatusEnumMap[instance.status]!,
      'expiration': instance.expiration?.toIso8601String(),
      'price': instance.price,
      'currency': instance.currency,
      'paymentMethod': instance.paymentMethod,
      'cardNumber': instance.cardNumber,
      'products': instance.products,
    };

const _$ReceiptStatusEnumMap = {
  ReceiptStatus.active: 'active',
  ReceiptStatus.expired: 'expired',
  ReceiptStatus.partial_return: 'partial_return',
  ReceiptStatus.returned: 'returned',
};
