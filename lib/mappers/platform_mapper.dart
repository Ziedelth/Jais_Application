import 'dart:convert';

import 'package:jais/models/platform.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:url/url.dart';

class PlatformMapper {
  static final instance = PlatformMapper();
  List<Platform> list = [];

  List<Platform>? stringToPlatforms(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Platform.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> update() async {
    if (list.isNotEmpty) return;

    final response = await URL().get(getPlatformsUrl());

    if (response == null || response.statusCode != 200) {
      return;
    }

    final platforms = stringToPlatforms(fromBrotli(response.body));

    if (platforms == null || platforms.isEmpty) {
      return;
    }

    list = platforms;
  }
}
