import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/country.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

class EpisodeMapper {
  static const limit = 12;
  int currentPage = 1;
  List<Widget> list = _defaultList;

  static List<Widget> get _defaultList => List.filled(
        limit,
        const EpisodeLoaderWidget(),
        growable: true,
      );

  void clear() {
    currentPage = 1;
    list = _defaultList;
  }

  void addLoader() => list.addAll(_defaultList);

  void removeLoader() =>
      list.removeWhere((element) => element is EpisodeLoaderWidget);

// Convert a String? to a List<Episode>?
  static List<Episode>? stringToEpisodes(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

// Convert a List<Episode> to List<EpisodeWidget>
  static List<EpisodeWidget> episodesToWidgets(List<Episode> episodes) {
    return episodes.map((e) => EpisodeWidget(episode: e)).toList();
  }

// Update the list of episodes
  Future<void> updateCurrentPage({
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    final link =
        'https://api.ziedelth.fr/v1/episodes/country/${Country.name}/page/$currentPage/limit/$limit';
    final url = URL();
    logger.info('Fetching $link');
    final response = await url.get(link);
    logger.info('Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      logger.warning('Failed to fetch episodes');
      onFailure?.call();
      return;
    }

    logger.info('Successfully fetched episodes');
    final episodes = stringToEpisodes(utf8.decode(response.bodyBytes));

    // If episodes is null or empty, then the request failed
    if (episodes == null || episodes.isEmpty) {
      logger.warning('Failed to convert in episodes list');
      onFailure?.call();
      return;
    }

    logger.info('Successfully converted in episodes list');
    // Convert the episodes to widgets
    final widgets = episodesToWidgets(episodes);

    // Remove the loader
    removeLoader();
    // Add widgets to the list
    list.addAll(widgets);
    // Call the onSuccess callback
    onSuccess?.call();
  }
}
