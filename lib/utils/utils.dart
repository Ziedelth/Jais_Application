import 'package:http/http.dart' as http;

String printTimeSince(DateTime? dateTime) {
  if (dateTime == null) {
    return 'erreur';
  }

  final double seconds = (DateTime.now().millisecondsSinceEpoch -
          dateTime.millisecondsSinceEpoch) /
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

  return "à l'instant";
}

String printDuration(Duration duration) {
  if (duration.isNegative) {
    return '??:??';
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final String twoDigitHours = twoDigits(duration.inHours);
  final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  if ((int.tryParse(twoDigitHours) ?? 0) > 0) {
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

Future<void> get(
  String url,
  Function(String) onSuccess,
  Function(String) onFailure,
) async {
  try {
    final http.Response response = await http.get(
      Uri.parse(
        url,
      ),
    );

    onSuccess(response.body);
  } catch (exception, stacktrace) {
    onFailure(stacktrace.toString());
  }
}

Future<void> post(
  String url,
  Object? headers,
  Function(String) onSuccess,
  Function(String) onFailure,
) async {
  try {
    final http.Response response = await http.post(
      Uri.parse(
        url,
      ),
      body: headers,
    );

    onSuccess(response.body);
  } catch (exception, stacktrace) {
    onFailure(stacktrace.toString());
  }
}

Future<void> put(
  String url,
  Object? headers,
  Function(String) onSuccess,
  Function(String) onFailure,
) async {
  try {
    final http.Response response = await http.put(
      Uri.parse(
        url,
      ),
      body: headers,
    );

    onSuccess(response.body);
  } catch (exception, stacktrace) {
    onFailure(stacktrace.toString());
  }
}
