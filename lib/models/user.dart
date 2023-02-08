import 'package:json_annotation/json_annotation.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String password;
  final DateTime joinedDate;
  final int count;
  final List<Receipt> receipts;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.joinedDate,
    required this.count,
    required this.receipts,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        joinedDate: DateTime.parse(json['joined_date'] as String),
        count: json['count'] as int,
        receipts: (json['receipts'] as List<dynamic>)
            .map((e) => Receipt.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'joinedDate': joinedDate,
        'count': count,
        'receipts': receipts,
      };
}
