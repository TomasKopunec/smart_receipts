import 'dart:convert';
import 'package:smart_receipts/helpers/requests/request_helper.dart';
import 'package:smart_receipts/models/return/return.dart';

enum ReturnsMethod {
  getReturns("returns", RequestType.get);

  final String path;
  final RequestType type;

  const ReturnsMethod(this.path, this.type);
}

class ReturnsRequestHelper extends RequestHelper {
  Future<ReturnsResponseDTO> getReturns(String token) async {
    const method = ReturnsMethod.getReturns;

    final response = await send(
      path: method.path,
      type: method.type,
      authToken: token,
    );

    bool success = response.code == 200;
    if (success) {
      final List<dynamic> parsed = json.decode(response.body);

      return ReturnsResponseDTO(
        status: success,
        message: "Returns fetched successfully.",
        returns: parsed.map((e) => Return.fromJson(e)).toList(),
      );
    } else {
      return ReturnsResponseDTO(
          status: success, message: json.decode(response.body)['msg']);
    }
  }
}

class ReturnsResponseDTO {
  bool status;
  String? message;
  List<Return>? returns;

  ReturnsResponseDTO({required this.status, this.message, this.returns});
}
