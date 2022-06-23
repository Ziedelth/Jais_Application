import 'dart:convert';

import 'package:jais/models/episode_type.dart';
import 'package:jais/utils/utils.dart';
import 'package:url/url.dart';

class EpisodeTypeMapper {
  List<EpisodeType> list = [];

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

  Future<void> update() async {
    final response = await URL().get(
      'https://api.ziedelth.fr/v2/episode-types',
    );

    if (response == null || response.statusCode != 200) {
      return;
    }

    final episodeTypes = stringToEpisodeTypes(fromBrotli(response.body));

    if (episodeTypes == null || episodeTypes.isEmpty) {
      return;
    }

    list = episodeTypes;
  }
}
