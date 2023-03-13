import 'dart:convert';
import 'package:smart_receipts/helpers/requests/request_helper.dart';

import '../../models/user.dart';

enum UserMethod {
  getProfile("profile", RequestType.get),
  changePassword("profile", RequestType.put),
  deleteAccount("profile", RequestType.delete);

  final String path;
  final RequestType type;

  const UserMethod(this.path, this.type);
}

class UserRequestHelper extends RequestHelper {
  Future<UserResponseDTO> getUser(String token) async {
    const method = UserMethod.getProfile;

    final response = await send(
      path: method.path,
      type: method.type,
      authToken: token,
    );

    bool success = response.code == 200;
    if (success) {
      final Map<String, dynamic> parsed = json.decode(response.body);
      return UserResponseDTO(
        status: success,
        message: "User fetched successfully.",
        user: User.fromJson(parsed),
      );
    } else {
      return UserResponseDTO(
          status: success, message: json.decode(response.body)['msg']);
    }
  }

  Future<UserResponseDTO> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
    required String newPasswordRepeat,
  }) async {
    const method = UserMethod.changePassword;

    final response = await send(
      path: method.path,
      type: method.type,
      body: json.encode({
        'email': email,
        'old_password': oldPassword,
        'new_password': newPassword,
        'new_password_repeat': newPasswordRepeat
      }),
    );

    bool success = response.code == 200;
    if (success) {
      return UserResponseDTO(
          status: success,
          message:
              "Password changed successfully. You can now log in with your new password.");
    } else {
      return UserResponseDTO(
          status: success, message: json.decode(response.body)['msg']);
    }
  }

  Future<UserResponseDTO> deleteAccount({
    required String token,
    required String email,
    required String password,
  }) async {
    const method = UserMethod.deleteAccount;

    final response = await send(
      authToken: token,
      path: method.path,
      type: method.type,
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    bool success = response.code == 204;
    if (success) {
      return UserResponseDTO(
          status: success, message: "Account deleted successfully.");
    } else {
      return UserResponseDTO(
          status: success, message: json.decode(response.body)['msg']);
    }
  }
}

class UserResponseDTO {
  bool status;
  String? message;
  User? user;

  UserResponseDTO({required this.status, this.message, this.user});
}
