import 'dart:convert';
import 'package:smart_receipts/helpers/requests/request_helper.dart';

import '../../models/user.dart';

enum UserMethod {
  getProfile("profile", RequestType.get);

  final String path;
  final RequestType type;

  const UserMethod(this.path, this.type);
}

class UserRequestHelper extends RequestHelper {
  Future<UserResponseDTO> getUser(String token) async {
    const method = UserMethod.getProfile;

    final response = await send(
      name: method.name,
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
}

class UserResponseDTO {
  bool status;
  String? message;
  User? user;

  UserResponseDTO({required this.status, this.message, this.user});
}
