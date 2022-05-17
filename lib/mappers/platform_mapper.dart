import 'dart:convert';

import 'package:jais/models/platform.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

class PlatformMapper {
  List<Platform> list = [];

  // Convert a String? to a List<Platform>?
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

  // Update the list of platforms
  Future<void> update() async {
    const link = 'https://api.ziedelth.fr/v1/platforms';
    final url = URL();
    logger.info('Fetching $link');
    final response = await url.get(link);
    logger.info('Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      logger.warning('Failed to fetch $link');
      return;
    }

    logger.info('Successfully fetched $link');
    final platforms = stringToPlatforms(utf8.decode(response.bodyBytes));

    // If platforms is null or empty, then the request failed
    if (platforms == null || platforms.isEmpty) {
      logger.warning('Failed to convert in platforms list');
      return;
    }

    logger.info('Successfully converted in platforms list');
    list = platforms;
  }
}
