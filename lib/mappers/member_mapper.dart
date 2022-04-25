import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart' as logger;
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

late final GetStorage _getStorage;

Future<void> init() async {
  logger.info("Initializing member mapper");
  await GetStorage.init('member_data');
  _getStorage = GetStorage('member_data');
  logger.info("Initializing member mapper done");
}

// Is connected, check if token key is present and pseudo is present
bool isConnected() {
  return _getStorage.hasData('token') && _getStorage.hasData('pseudo');
}

// Login, save token and pseudo
void login(String token, String pseudo, List<dynamic>? watchlist) {
  _getStorage.write('token', token);
  _getStorage.write('pseudo', pseudo);
  setWatchlist(watchlist);
}

Future<void> loginWithToken() async {
  if (!isConnected()) {
    return;
  }

  try {
    final response = await URL().post(
      "https://api.ziedelth.fr/v1/member/token",
      body: {
        "token": getToken()!,
      },
    );

    // If response is null or response code is not 200, return an error
    if (response == null || response.statusCode != 200) {
      logout();
      throw Exception("Error while logging in");
    }

    // Decode response
    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    // If responseBody not contains token and pseudo, return an error
    if (!responseBody.containsKey('token') ||
        !responseBody.containsKey('pseudo')) {
      logout();
      throw Exception("Error while logging in");
    }

    // Save token and pseudo in shared preferences
    login(responseBody['token'] as String, responseBody['pseudo'] as String, responseBody['watchlist'] as List<dynamic>?);
  } catch (exception, stackTrace) {
    logger.error(
      'Exception when trying to login',
      exception: exception,
      stackTrace: stackTrace,
    );
  }
}

// Logout, remove token and pseudo
void logout() {
  _getStorage.remove('token');
  _getStorage.remove('pseudo');
  _getStorage.remove('watchlist');
}

// Get token is member is connected
String? getToken() {
  if (!isConnected()) {
    return null;
  }

  return _getStorage.read('token');
}

// Get pseudo is member is connected
String? getPseudo() {
  if (!isConnected()) {
    return null;
  }

  return _getStorage.read('pseudo');
}

// Set watchlist, save watchlist in shared preferences
void setWatchlist(List<dynamic>? watchlist) {
  _getStorage.write('watchlist', watchlist);
}

// Has anime id in watchlist
bool hasAnimeInWatchlist(int animeId) {
  if (!isConnected()) {
    return false;
  }

  final watchlist = _getStorage.read('watchlist') as List<dynamic>? ?? [];
  return watchlist.contains(animeId);
}

// Add anime id in watchlist
Future<void> addAnimeInWatchlist(int animeId) async {
  if (!isConnected()) {
    return;
  }

  if (hasAnimeInWatchlist(animeId)) {
    return;
  }

  final watchlist = _getStorage.read('watchlist') as List<dynamic>? ?? [];
  watchlist.add(animeId);
  _getStorage.write('watchlist', watchlist);

  try {
    await URL().post(
      "https://api.ziedelth.fr/v1/watchlist/add",
      body: {
        "token": getToken()!,
        "animeId": animeId.toString(),
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

// Remove anime id in watchlist
Future<void> removeAnimeInWatchlist(int animeId) async {
  if (!isConnected()) {
    return;
  }

  if (!hasAnimeInWatchlist(animeId)) {
    return;
  }

  final watchlist = _getStorage.read('watchlist') as List<dynamic>? ?? [];
  watchlist.remove(animeId);
  _getStorage.write('watchlist', watchlist);

  try {
    await URL().post(
      "https://api.ziedelth.fr/v1/watchlist/remove",
      body: {
        "token": getToken()!,
        "animeId": animeId.toString(),
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
