import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/member.dart';
import 'package:logger/logger.dart' as logger;
import 'package:notifications/notifications.dart' as notifications;
import 'package:url/url.dart';

// Email regex
final emailRegExp = RegExp(
  r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
);

// Pseudo regex with min 4 characters and max 16 characters, with only letters and numbers
final pseudoRegExp = RegExp(
  r'^[a-zA-Z\d]{4,16}$',
);

// Password regex (at least 8 characters, at least 1 uppercase, at least 1 lowercase, at least 1 number, at least 1 special character)
final passwordRegExp = RegExp(
  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
);

final inputFormatters = [
  FilteringTextInputFormatter.deny(RegExp(r'\s')),
];

late final GetStorage _getStorage;

Future<void> init() async {
  logger.info("Initializing member mapper");
  await GetStorage.init('member_data');
  _getStorage = GetStorage('member_data');
  logger.info("Initializing member mapper done");
}

// Get member save in storage
Member? getMember() {
  final memberJson = _getStorage.read('member') as String?;

  if (memberJson == null) {
    return null;
  }

  return Member.fromJson(jsonDecode(memberJson) as Map<String, dynamic>);
}

void setMember(Member? member) {
  if (member == null) {
    _getStorage.remove('member');
  } else {
    _getStorage.write('member', jsonEncode(member.toJson()));
  }
}

// Is connected, check if token key is present and pseudo is present
bool isConnected() {
  final member = getMember();
  return member != null && member.token != null && member.token!.isNotEmpty;
}

Future<void> loginWithToken() async {
  if (!isConnected()) {
    return;
  }

  try {
    final response = await URL().post(
      "https://api.ziedelth.fr/v1/member/token",
      body: {
        "token": getMember()!.token!,
      },
    );

    // If response is null or response code is not 200, return an error
    if (response == null || response.statusCode != 200) {
      setMember(null);
      throw Exception("Error while logging in");
    }

    // Decode response to member
    final member = Member.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

    // If responseBody not contains token, return an error
    if (member.token == null) {
      setMember(null);
      throw Exception("Error while logging in");
    }

    // Save token and pseudo in shared preferences
    setMember(member);
  } catch (exception, stackTrace) {
    logger.error(
      'Exception when trying to login',
      exception: exception,
      stackTrace: stackTrace,
    );
  }
}

// Has anime in watchlist
bool hasAnimeInWatchlist(Anime anime) {
  if (!isConnected()) {
    return false;
  }

  return getMember()?.watchlist.any((element) => element.id == anime.id) ?? false;
}

// Add anime in watchlist
Future<void> addAnimeInWatchlist(Anime anime) async {
  if (!isConnected()) {
    return;
  }

  if (hasAnimeInWatchlist(anime)) {
    return;
  }

  final member = getMember()!;
  member.watchlist.add(anime);
  setMember(member);

  try {
    await URL().post(
      "https://api.ziedelth.fr/v1/watchlist/add",
      body: {
        "token": member.token!,
        "animeId": anime.id.toString(),
      },
    );
  } catch (exception, stackTrace) {
    logger.error(
      'Exception when trying to add anime in watchlist',
      exception: exception,
      stackTrace: stackTrace,
    );
  }
}

// Remove anime in watchlist
Future<void> removeAnimeInWatchlist(Anime anime) async {
  if (!isConnected()) {
    return;
  }

  if (!hasAnimeInWatchlist(anime)) {
    return;
  }

  final member = getMember()!;
  member.watchlist.removeWhere((element) => element.id == anime.id);
  setMember(member);

  try {
    await URL().post(
      "https://api.ziedelth.fr/v1/watchlist/remove",
      body: {
        "token": member.token!,
        "animeId": anime.id.toString(),
      },
    );
  } catch (exception, stackTrace) {
    logger.error(
      'Exception when trying to remove anime in watchlist',
      exception: exception,
      stackTrace: stackTrace,
    );
  }
}

String notificationsMode() {
  if (notifications.hasTopic("animes")) {
    return "default";
  } else {
    return "watchlist";
  }
}

void setDefaultNotifications() {
  notifications.removeAllTopics();
  notifications.addTopic("animes");
  logger.info("Set default notifications");
}

void setWatchlistNotifications() {
  if (!isConnected()) {
    return;
  }

  notifications.removeAllTopics();

  for (final anime in getMember()!.watchlist) {
    notifications.addTopic(anime.id.toString());
  }
}

String roleToString(int? role) {
  switch (role) {
    case 100:
      return "Administrateur";
    case 0:
    default:
      return "Membre";
  }
}
