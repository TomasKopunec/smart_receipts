import 'dart:convert';

import 'package:smart_receipts/helpers/requests/request_helper.dart';
import 'package:smart_receipts/providers/auth/token.dart';

enum AuthMethod {
  register("auth/register", RequestType.post),
  login("auth/login", RequestType.post),
  logout("auth/logout", RequestType.post);

  final String path;
  final RequestType type;

  const AuthMethod(this.path, this.type);
}

class AuthRequestHelper extends RequestHelper {
  Future<AuthResponseDTO> register(String email, String password) async {
    const method = AuthMethod.register;
    final response = await send(method.name, method.type, method.path,
        json.encode({'email': email, 'password': password}));

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
    const method = AuthMethod.login;
    final response = await send(method.name, method.type, method.path,
        json.encode({'email': email, 'password': password}));

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

  Future<bool> logout(String tokenId) async {
    const method = AuthMethod.logout;
    final response = await send(method.name, method.type, method.path,
        json.encode({'access_token': tokenId}));
    return response.code == 200;
  }
}

class AuthResponseDTO {
  bool status;
  String message;
  Token? token;

  AuthResponseDTO({required this.status, this.message = "", this.token});
}
