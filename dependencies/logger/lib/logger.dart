library logger;

import 'dart:developer' as dev;

import 'package:intl/intl.dart';
import 'package:logger/log_type.dart';
import 'package:stack_trace/stack_trace.dart';

void log({required LogType logType, required String message}) {
  final frame = Trace.current().frames[2];
  final String format =
      '[${DateFormat('HH:mm:ss.SSSS dd/MM/yyyy').format(DateTime.now())} ${logType.name.toUpperCase()}\t${frame.member} -> ${frame.line}:${frame.column}] $message';
  dev.log(format);
}

void info(String message) => log(logType: LogType.info, message: message);

void debug(String message) => log(logType: LogType.debug, message: message);

void warning(String message) => log(logType: LogType.warning, message: message);

void error(String message, [Object? exception, StackTrace? stackTrace]) => log(
      logType: LogType.error,
      message: '$message${exception.nextLine()}${stackTrace.nextLine()}',
    );

extension _QString on Object? {
  String nextLine() => this == null ? '' : '\n${toString()}';
}
