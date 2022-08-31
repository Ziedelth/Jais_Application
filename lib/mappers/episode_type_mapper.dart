import 'dart:convert';

import 'package:jais/models/episode_type.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:logger/logger.dart';
import 'package:url/url.dart';

class EpisodeTypeMapper {
  static final instance = EpisodeTypeMapper();
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
    if (list.isNotEmpty) return;

    Logger.info('Get all episode types...');
    final response = await URL().get(getEpisodeTypesUrl());

    if (response == null || response.statusCode != 200) {
      Logger.error('An error occurred while getting all episode types');
      return;
    }

    final episodeTypes = stringToEpisodeTypes(fromBrotli(response.body));

    if (episodeTypes == null || episodeTypes.isEmpty) {
      Logger.error('An error occurred while getting all episode types');
      return;
    }

    Logger.debug('Episode types: ${episodeTypes.length}');
    episodeTypes.removeWhere((element) => element.name == 'UNKNOWN');
    list = episodeTypes;
  }
}
