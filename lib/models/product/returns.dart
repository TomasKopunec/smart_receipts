class Returns {
  final bool returned;
  final DateTime? returnedDate;

  Returns(this.returned, this.returnedDate);

  static Returns fromJson(Map<String, dynamic> json) {
    String date = json['returned_date'];
    return Returns(
        json['returned'], date.isEmpty ? null : DateTime.parse(date));
  }

  Map<String, dynamic> toJson() {
    return {
      'returned': returned,
      'returned_date':
          returnedDate != null ? returnedDate!.toIso8601String() : "",
    };
  }
}
