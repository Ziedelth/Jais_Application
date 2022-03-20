import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jais/models/user.dart';
import 'package:jais/utils/utils.dart';

class UserMapper {
  static final GetStorage getStorage = GetStorage();
  static const KEY = "token";
  static String? token;
  static User? user;

  static void fromResponse(Map<String, dynamic> json) {
    if (!json.containsKey('token')) {
      return;
    }

    token = json['token'];
    user = User.fromJson(json['user']);
    getStorage.write(KEY, token);
  }

  static Future<void> tryToLogin({VoidCallback? callback}) async {
    if (isConnected()) {
      callback?.call();
      return;
    }

    debugPrint('Has token saved: ${getStorage.hasData(KEY)}');

    if (!getStorage.hasData(KEY)) {
      return;
    }

    final String localToken = getStorage.read(KEY);
    debugPrint('Local token: $localToken');

    await Utils.post(
      'https://ziedelth.fr/api/v1/member/login/token',
      {
        "token": localToken,
      },
      (success) {
        final Map<String, dynamic> json = jsonDecode(success);

        if (json.containsKey('error')) {
          return;
        }

        fromResponse(json);
        callback?.call();
      },
      (failure) => null,
    );
  }

  static bool isConnected() {
    return token != null && user != null;
  }

  static void logout() {
    if (!isConnected()) {
      return;
    }

    token = null;
    user = null;
    getStorage.remove(KEY);
  }
}
