import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/member.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:logger/logger.dart';
import 'package:notifications/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url/url.dart';

class MemberMapper {
  static final instance = MemberMapper();

  final emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z\d-]+)*$',
  );
  final pseudoRegExp = RegExp(r'^[a-zA-Z\d]{4,16}$');
  final passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  final inputFormatters = [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  late final SharedPreferences _sharedPreferences;
  final _memberKey = 'member';

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Member? getMember() {
    final memberJson = _sharedPreferences.containsKey(_memberKey)
        ? _sharedPreferences.getString(_memberKey)
        : null;

    if (memberJson == null) {
      return null;
    }

    return Member.fromJson(jsonDecode(memberJson) as Map<String, dynamic>);
  }

  Future<void> setMember(Member? member) async {
    if (member == null) {
      await _sharedPreferences.remove(_memberKey);
    } else {
      await _sharedPreferences.setString(
        _memberKey,
        jsonEncode(member.toJson()),
      );
    }
  }

  bool isConnected() {
    final member = getMember();
    return member != null && member.token != null && member.token!.isNotEmpty;
  }

  Future<void> loginWithToken() async {
    Logger.info('Logging in with token...');

    if (!isConnected()) {
      Logger.warning('Not connected');
      return;
    }

    try {
      Logger.info('Logging in...');

      final response = await URL().post(
        getLoginWithTokenUrl(),
        body: {
          "token": getMember()!.token!,
        },
      );

      if (response == null || response.statusCode != 200) {
        await setMember(null);
        throw Exception("Error while logging in");
      }

      Logger.debug('Decoding response...');
      final member = Member.fromJson(
        jsonDecode(fromBrotli(response.body)) as Map<String, dynamic>,
      );

      if (member.token == null) {
        await setMember(null);
        throw Exception("Error while logging in");
      }

      Logger.debug('Logged in as ${member.pseudo}');
      await setMember(member);
    } catch (exception, stacktrace) {
      Logger.error('An error occurred while logging in', exception, stacktrace);
    }
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

    final isWatchlistMode = Notifications.instance.getType() == 'watchlist';

    if (isWatchlistMode) {
      await Notifications.instance.addTopic(anime.id.toString());
    }

    final member = getMember()!;
    member.watchlist.add(anime);
    await setMember(member);

    try {
      await URL().post(
        getWatchlistAddUrl(),
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

    final isWatchlistMode = Notifications.instance.getType() == 'watchlist';

    if (isWatchlistMode) {
      await Notifications.instance.removeTopic(anime.id.toString());
    }

    final member = getMember()!;
    member.watchlist.removeWhere((element) => element.id == anime.id);
    await setMember(member);

    try {
      await URL().post(
        getWatchlistRemoveUrl(),
        body: {
          "token": member.token!,
          "animeId": anime.id.toString(),
        },
      );
    } catch (_) {}
  }

  Future<void> setDefaultNotifications() async {
    await Notifications.instance.setType("default");
    await Notifications.instance.removeAllTopics();
    await Notifications.instance.addTopic("animes");
  }

  Future<void> setWatchlistNotifications() async {
    if (!isConnected()) {
      return;
    }

    await Notifications.instance.setType("watchlist");
    await Notifications.instance.removeAllTopics();

    for (final anime in getMember()!.watchlist) {
      await Notifications.instance.addTopic(anime.id.toString());
    }
  }

  Future<void> setDisabledNotifications() async {
    if (!isConnected()) {
      return;
    }

    await Notifications.instance.setType("disable");
    await Notifications.instance.removeAllTopics();
  }
}
