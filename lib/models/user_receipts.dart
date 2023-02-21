import 'package:smart_receipts/models/receipt/receipt.dart';

class UserReceipts {
  final String id;
  final String email;
  final List<Receipt> receipts;

  UserReceipts({
    required this.id,
    required this.email,
    required this.receipts,
  });

  static UserReceipts fromJson(Map<String, dynamic> json) => UserReceipts(
        id: json['id'] as String,
        email: json['email'] as String,
        receipts: (json['receipts'] as List<dynamic>)
            .map((e) => Receipt.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
