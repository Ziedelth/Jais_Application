import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class Logger {
  static const int limit = 5000;
  static final GetStorage box = GetStorage();
  static const String key = 'logger';
  static List<String> logs = [];

  static void init() {
    (box.read(key) ?? [])
        .map((e) => e.toString())
        .toList()
        .forEach((e) => logs.add(e));
  }

  static void log({required LogType logType, required String message}) {
    final format =
        '[${DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.now())} ${logType.name.toUpperCase()}] $message';

    if (logs.length > limit) {
      logs.removeAt(0);
    }

    if (kDebugMode) {
      print(format);
    }

    logs.add(format);
    box.write(key, logs);
  }

  static void info({required String message}) =>
      log(logType: LogType.info, message: message);

  static void debug({required String message}) =>
      log(logType: LogType.debug, message: message);

  static void warn({required String message}) =>
      log(logType: LogType.warn, message: message);

  static void error({required String message}) =>
      log(logType: LogType.error, message: message);
}

enum LogType { info, debug, warn, error }
