import 'dart:convert';

import 'package:jais/models/platform.dart';
import 'package:jais/utils/decompress.dart';
import 'package:url/url.dart';

class PlatformMapper {
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
    final response = await URL().get(
      'https://api.ziedelth.fr/v2/platforms',
    );

    if (response == null || response.statusCode != 200) {
      return;
    }

    final platforms = stringToPlatforms(fromBrotly(response.body));

    if (platforms == null || platforms.isEmpty) {
      return;
    }

    list = platforms;
  }
}
