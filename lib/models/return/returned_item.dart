class ReturnedItem {
  final String sku;
  final int quantity;
  final DateTime returnDateTime;

  ReturnedItem({
    required this.sku,
    required this.quantity,
    required this.returnDateTime,
  });

  Map<String, dynamic> toJson() => {
        'sku': sku,
        'quantity': quantity,
        'return_datetime': returnDateTime.toIso8601String()
      };

  static ReturnedItem fromJson(Map<String, dynamic> json) => ReturnedItem(
        sku: json['sku'],
        quantity: int.parse(json['quantity']),
        returnDateTime: DateTime.parse(json['return_datetime']),
      );
}
