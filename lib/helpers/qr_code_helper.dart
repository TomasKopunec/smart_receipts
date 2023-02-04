import 'dart:convert';

class QrCodeHelper {
  static String getReceiveReceiptQrCode(String id, bool digitalOnly) {
    return json.encode({
      "customer_id": id,
      "digital_only": digitalOnly,
    });
  }
}
