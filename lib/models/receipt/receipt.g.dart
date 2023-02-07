// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) => Receipt(
      id: json['id'] as int,
      auto_delete_date_time: json['auto_delete_date_time'] == null
          ? null
          : DateTime.parse(json['auto_delete_date_time'] as String),
      retailer_receipt_id: json['retailer_receipt_id'] as int,
      retailer_id: json['retailer_id'] as int,
      retailer_name: json['retailer_name'] as String,
      customer_email: json['customer_email'] as String,
      purchase_date_time: DateTime.parse(json['purchase_date_time'] as String),
      purchase_location: json['purchase_location'] as String,
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
      'id': instance.id,
      'auto_delete_date_time':
          instance.auto_delete_date_time?.toIso8601String(),
      'retailer_receipt_id': instance.retailer_receipt_id,
      'retailer_id': instance.retailer_id,
      'retailer_name': instance.retailer_name,
      'customer_email': instance.customer_email,
      'purchase_date_time': instance.purchase_date_time.toIso8601String(),
      'purchase_location': instance.purchase_location,
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
  ReceiptStatus.returned: 'returned',
};
