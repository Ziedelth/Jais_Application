import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jais/models/user.dart';
import 'package:jais/utils/utils.dart';

final GetStorage getStorage = GetStorage();
const key = "token";
String? token;
User? user;

void fromResponse(Map<String, dynamic> json) {
  if (!json.containsKey('token')) {
    return;
  }

  token = json['token'] as String;
  user = User.fromJson(json['user'] as Map<String, dynamic>);
  getStorage.write(key, token);
}

Future<void> tryToLogin({VoidCallback? callback}) async {
  if (isConnected()) {
    callback?.call();
    return;
  }

  debugPrint('Has token saved: ${getStorage.hasData(key)}');

  if (!getStorage.hasData(key)) {
    return;
  }

  final String localToken = getStorage.read(key) as String;
  debugPrint('Local token: $localToken');

  await post(
    'https://ziedelth.fr/api/v1/member/login/token',
    {
      "token": localToken,
    },
    (success) {
      final Map<String, dynamic> json =
          jsonDecode(success) as Map<String, dynamic>;

      if (json.containsKey('error')) {
        return;
      }

      fromResponse(json);
      callback?.call();
    },
    (failure) => null,
  );
}

bool isConnected() {
  return token != null && user != null;
}

void logout() {
  if (!isConnected()) {
    return;
  }

  token = null;
  user = null;
  getStorage.remove(key);
}
