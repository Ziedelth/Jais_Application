import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as logger;

void printErrorSnackBar(
  BuildContext context,
  String message, [
  Object? exception,
  StackTrace? stackTrace,
]) {
  logger.error(message, exception: exception, stackTrace: stackTrace);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: ErrorWidget(message),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
  );
}

Widget printErrorWidget(
  String message, [
  Object? exception,
  StackTrace? stackTrace,
]) {
  logger.error(message, exception: exception, stackTrace: stackTrace);

  return Center(
    child: ErrorWidget(message),
  );
}

class ErrorWidget extends StatelessWidget {
  final String _message;

  ErrorWidget(
    this._message, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFC72C41),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Oh crap!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
