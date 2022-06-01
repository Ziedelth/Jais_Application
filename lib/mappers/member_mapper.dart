import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/member.dart';
import 'package:jais/models/member_role.dart';
import 'package:jais/utils/decompress.dart';
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
  await GetStorage.init('member_data');
  _getStorage = GetStorage('member_data');
}

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

    if (response == null || response.statusCode != 200) {
      setMember(null);
      throw Exception("Error while logging in");
    }

    final member = Member.fromJson(
      jsonDecode(fromBrotly(response.body)) as Map<String, dynamic>,
    );

    if (member.token == null) {
      setMember(null);
      throw Exception("Error while logging in");
    }

    setMember(member);
  } catch (_) {}
}

bool hasAnimeInWatchlist(Anime anime) {
  if (!isConnected()) {
    return false;
  }

  return getMember()?.watchlist.any((element) => element.id == anime.id) ??
      false;
}

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
  } catch (_) {}
}

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
  } catch (_) {}
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
    case MemberRole.admin:
      return "Administrateur";
    case 0:
    default:
      return "Membre";
  }
}
