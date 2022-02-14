import 'package:http/http.dart' as http;

import 'logger.dart';

class Utils {
  static String printTimeSince(DateTime dateTime) {
    final double seconds = (DateTime.now().millisecondsSinceEpoch.floor() -
            dateTime.millisecondsSinceEpoch.floor()) /
        1000;
    double interval = seconds / 31536000;

    if (interval > 1) {
      return '${interval.floor()} an${interval >= 2 ? 's' : ''}';
    }

    interval = seconds / 2592000;

    if (interval > 1) {
      return '${interval.floor()} mois';
    }

    interval = seconds / 86400;

    if (interval > 1) {
      return '${interval.floor()} jour${interval >= 2 ? 's' : ''}';
    }

    interval = seconds / 3600;

    if (interval > 1) {
      return '${interval.floor()} heure${interval >= 2 ? 's' : ''}';
    }

    interval = seconds / 60;

    if (interval > 1) {
      return '${interval.floor()} minute${interval >= 2 ? 's' : ''}';
    }

    return 'A l\'instant';
  }

  static String printDuration(Duration duration) {
    if (duration.isNegative) {
      return '??:??';
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if ((int.tryParse(twoDigitHours) ?? 0) > 0) {
      return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }

  static Future<void> request(String url, int successCode,
      Function(String) onSuccess, Function(String) onFailure) async {
    try {
      Logger.debug(message: 'Making request $url...');

      final http.Response response = await http.get(
        Uri.parse(
          url,
        ),
      );

      if (response.statusCode != successCode) {
        Logger.warn(message: 'Bad response! Body: ${response.body}');
        onFailure(response.body);
        return;
      }

      Logger.info(message: 'Good response!');
      onSuccess(response.body);
    } catch (exception, stacktrace) {
      Logger.error(message: 'Error : $exception - ${stacktrace.toString()}');
      onFailure(stacktrace.toString());
    }
  }
}
