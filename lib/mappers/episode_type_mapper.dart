import 'dart:convert';

import 'package:jais/models/episode_type.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

class EpisodeTypeMapper {
  List<EpisodeType> list = [];

  // Convert a String? to a List<EpisodeType>?
  List<EpisodeType>? stringToEpisodeTypes(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => EpisodeType.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  // Update the list of platforms
  Future<void> update() async {
    const link = 'https://api.ziedelth.fr/v1/episode-types';
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
    final episodeTypes = stringToEpisodeTypes(utf8.decode(response.bodyBytes));

    // If episodeTypes is null or empty, then the request failed
    if (episodeTypes == null || episodeTypes.isEmpty) {
      logger.warning('Failed to convert in episodeTypes list');
      return;
    }

    logger.info('Successfully converted in episodeTypes list');
    list = episodeTypes;
  }
}
