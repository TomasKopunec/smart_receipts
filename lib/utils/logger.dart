import 'package:intl/intl.dart';

class Logger {
  final Type type;

  Logger(this.type);

  void log(Object message, {String? name}) {
    final String timeStamp = DateFormat('HH:mm:ss:SSS').format(DateTime.now());
    print(
        "$timeStamp [${name == null ? type.toString().toUpperCase() : name.toUpperCase()}] ${message.toString()}");
  }
}
