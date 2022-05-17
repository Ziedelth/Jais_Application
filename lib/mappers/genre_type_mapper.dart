import 'dart:convert';

import 'package:jais/models/genre.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

class GenreMapper {
  List<Genre> list = [];

  // Convert a String? to a List<Genre>?
  List<Genre>? stringToGenres(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  // Update the list of Genre
  Future<void> update() async {
    const link = 'https://api.ziedelth.fr/v1/genres';
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
    final genres = stringToGenres(utf8.decode(response.bodyBytes));

    // If genres is null or empty, then the request failed
    if (genres == null || genres.isEmpty) {
      logger.warning('Failed to convert in genres list');
      return;
    }

    logger.info('Successfully converted in genres list');
    list = genres;
  }
}
