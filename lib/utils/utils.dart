import 'package:flutter/material.dart';

bool isOnMobile(BuildContext context) =>
    MediaQuery.of(context).size.width < 600;

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

// Show a snackbar with a message
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
