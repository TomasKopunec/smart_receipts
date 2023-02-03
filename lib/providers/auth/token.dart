class Token {
  final String accessToken;
  final DateTime expiresAt;

  Token({
    required this.accessToken,
    required this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
      "expiresAt": expiresAt.toIso8601String(),
    };
  }

  static Token fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'],
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}
