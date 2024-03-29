import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_receipts/helpers/size_helper.dart';

import '../models/product/product.dart';

class QrCodeHelper {
  static getReceiveQrCodeWidget(
      BuildContext context, String email, bool digitalOnly) {
    return getQrImageWidget(
      context,
      getReceiveReceiptQrData(email, digitalOnly),
      size: SizeHelper.getScreenWidth(context) * 0.8,
    );
  }

  static getReturnQrCodeWidget(BuildContext context, String email,
      String receiptId, Map<Product, int> products,
      {double? size}) {
    return getQrImageWidget(
        context,
        getReturnQrCodeData(
            email: email, receiptId: receiptId, products: products),
        size: size);
  }

  static getQrImageWidget(BuildContext context, String data, {double? size}) {
    return QrImage(
      data: data,
      padding: EdgeInsets.zero,
      version: QrVersions.auto,
      constrainErrorBounds: true,
      size: size,
      foregroundColor: Theme.of(context).indicatorColor,
      backgroundColor: Colors.transparent,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
      gapless: false,
    );
  }

  static String getReceiveReceiptQrData(String email, bool digitalOnly) {
    return json.encode({
      "customer_id": email,
      "digital_only": digitalOnly,
    });
  }

  static String getReturnQrCodeData(
      {required String receiptId,
      required String email,
      required Map<Product, int> products}) {
    return json.encode({
      "receipt_id": receiptId,
      "customer_email": email,
      "returned_items": products.entries
          .map((e) => {'sku': e.key.sku, 'quantity': e.value})
          .toList(),
    });
  }
}
