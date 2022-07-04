import 'dart:convert';
import 'dart:typed_data';

import 'package:brotli/brotli.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

BannerAd? globalBannerAd;

void createGlobalBanner() {
  globalBannerAd = BannerAd(
    adUnitId: 'ca-app-pub-5658764393995798/7021730383',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
      },
    ),
  );

  globalBannerAd?.load();
}

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

String fromUTF8(List<int> bytes) => utf8.decode(bytes);

Uint8List fromBase64(String string) => base64.decode(string);

String fromBrotli(String string) =>
    fromUTF8(brotli.decode(fromBase64(string.trim())));

const _mainColor = Color(0xFFF2B05E);

final int redMainColor = _mainColor.red;
final int greenMainColor = _mainColor.green;
final int blueMainColor = _mainColor.blue;

final Map<int, Color> mainColors = {
  50: Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    .1,
  ),
  100: Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    .2,
  ),
  200: Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    .3,
  ),
  300: Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    .4,
  ),
  400: Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    .5,
  ),
  500: Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    .6,
  ),
  600: Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    .7,
  ),
  700: Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    .8,
  ),
  800: Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    .9,
  ),
  900: Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    1,
  ),
};

Future<bool> needsToShowReview() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  const acceptReviewKey = 'acceptReview';
  final acceptReview = sharedPreferences.getBool(acceptReviewKey) ?? true;

  if (acceptReview) {
    const counterKey = 'reviewCounter';
    var reviewCounter = sharedPreferences.getInt(counterKey) ?? 0;
    reviewCounter = (reviewCounter + 1) % 5;
    print('reviewCounter: $reviewCounter');
    await sharedPreferences.setInt(counterKey, reviewCounter);
    return reviewCounter == 0 && (await InAppReview.instance.isAvailable());
  }

  return false;
}
