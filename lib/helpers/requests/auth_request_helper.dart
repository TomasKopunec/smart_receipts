import 'dart:convert';

import 'package:smart_receipts/helpers/requests/request_helper.dart';
import 'package:smart_receipts/helpers/requests/response.dart';
import 'package:smart_receipts/providers/auth/token.dart';

class AuthRequestHelper extends RequestHelper {
  final String _registerPath = "auth/register";
  final String _loginPath = "auth/login";

  Future<AuthResponseDTO> register(String email, String password) async {
    print("[API] REGISTER: ($email, $password)");
    final body = json.encode({'email': email, 'password': password});
    final Response response =
        await send(RequestType.post, _registerPath, body: body);

    bool success = response.code == 201;
    if (success) {
      final Map<String, dynamic> parsed = json.decode(response.body);
      return AuthResponseDTO(
          status: success,
          message: "Registered successfully.",
          token: Token(
              accessToken: parsed['access_token'],
              expiresAt: DateTime.parse(
                parsed['expires_at'],
              )));
    } else {
      return AuthResponseDTO(
          status: success, message: json.decode(response.body)['msg']);
    }
  }

  Future<AuthResponseDTO> login(String email, String password) async {
    print("[API] LOGIN: ($email, $password)");
    final body = json.encode({'email': email, 'password': password});
    final Response response =
        await send(RequestType.post, _loginPath, body: body);

    bool success = response.code == 200;
    final parsed = json.decode(response.body);
    if (success) {
      final Token token = Token(
          accessToken: parsed['access_token'],
          expiresAt: DateTime.parse(
            parsed['expires_at'],
          ));
      return AuthResponseDTO(
          status: success, message: "Logged-in successfully.", token: token);
    } else {
      return AuthResponseDTO(status: success, message: parsed['msg']);
    }
  }
}

class AuthResponseDTO {
  bool status;
  String message;
  Token? token;

  AuthResponseDTO({required this.status, this.message = "", this.token});
}
