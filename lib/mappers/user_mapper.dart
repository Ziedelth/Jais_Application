import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jais/models/user.dart';
import 'package:jais/utils/utils.dart';

final GetStorage _getStorage = GetStorage();
const _key = "token";
String? token;
User? user;

void fromResponse(Map<String, dynamic> json) {
  if (!json.containsKey('token')) {
    return;
  }

  token = json['token'] as String;
  user = User.fromJson(json['user'] as Map<String, dynamic>);
  _getStorage.write(_key, token);
}

bool isConnected() => token != null && user != null;

Future<void> tryToLogin({VoidCallback? callback}) async {
  if (isConnected()) {
    callback?.call();
    return;
  }

  if (!_getStorage.hasData(_key)) {
    return;
  }

  final String localToken = _getStorage.read(_key) as String;

  await post(
    'https://ziedelth.fr/api/v1/member/login/token',
    {"token": localToken},
    (success) async {
      final Map<String, dynamic> json =
          jsonDecode(success) as Map<String, dynamic>;

      if (json.containsKey('error')) {
        return;
      }

      fromResponse(json);
    },
    (failure) => null,
  );
}

void logout() {
  if (!isConnected()) {
    return;
  }

  token = null;
  user = null;
  _getStorage.remove(_key);
}
