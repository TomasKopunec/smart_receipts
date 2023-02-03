enum ExceptionType { redirect, clientError, serverError }

class HttpException implements Exception {
  final ExceptionType type;
  final String message;

  HttpException(this.type, this.message);

  @override
  String toString() {
    return "${type.name} exception! Message: $message";
  }
}
