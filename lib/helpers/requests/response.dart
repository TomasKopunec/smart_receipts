class Response {
  final int code;
  final Map<String, String>? headers;
  final String body;
  final String? exception;

  Response({
    required this.code,
    this.headers,
    required this.body,
    this.exception,
  });
}
