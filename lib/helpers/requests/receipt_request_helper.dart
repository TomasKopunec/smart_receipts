import 'dart:convert';
import 'package:smart_receipts/helpers/requests/request_helper.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/models/user_receipts.dart';

enum ReceiptMethod {
  getReceipts("receipts", RequestType.get);

  final String path;
  final RequestType type;

  const ReceiptMethod(this.path, this.type);
}

class ReceiptsRequestHelper extends RequestHelper {
  Future<ReceiptResponseDTO> getReceipts(String token) async {
    const method = ReceiptMethod.getReceipts;

    final response = await send(
      name: method.name,
      path: method.path,
      type: method.type,
      authToken: token,
    );

    bool success = response.code == 200;
    if (success) {
      final Map<String, dynamic> parsed = json.decode(response.body);
      final userReceipts = UserReceipts.fromJson(parsed);

      return ReceiptResponseDTO(
        status: success,
        message: "Receipts fetched successfully.",
        receipts: userReceipts.receipts,
      );
    } else {
      return ReceiptResponseDTO(
          status: success, message: json.decode(response.body)['msg']);
    }
  }
}

class ReceiptResponseDTO {
  bool status;
  String? message;
  List<Receipt>? receipts;

  ReceiptResponseDTO({required this.status, this.message, this.receipts});
}
