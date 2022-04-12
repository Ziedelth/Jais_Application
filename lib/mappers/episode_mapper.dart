import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/url_mapper.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/country.dart';

const _limit = 9;
int currentPage = 1;
List<Widget> list = _defaultList;

List<Widget> get _defaultList => List.filled(
      _limit,
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
List<Episode>? stringToEpisodes(String? string) {
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
List<EpisodeWidget> episodesToWidgets(
  List<Episode> episodes, {
  Function(Episode episode)? onUp,
  Function(Episode episode)? onDown,
}) {
  return episodes
      .map(
        (e) => EpisodeWidget(
          episode: e,
          onUp: onUp,
          onDown: onDown,
        ),
      )
      .toList();
}

// Update the list of episodes
Future<void> updateCurrentPage({
  Function()? onSuccess,
  Function()? onFailure,
  Function(Episode episode)? onUp,
  Function(Episode episode)? onDown,
}) async {
  final url =
      'episodes/country/${Country.name}/page/$currentPage/limit/$_limit';
  final urlMapper = URLMapper();
  debugPrint('[EpisodeMapper] Fetching $url');

  final response = await urlMapper.getOwn(url);
  debugPrint('[EpisodeMapper] Response: ${response?.statusCode}');

  // If the response is null or the status code is not equals to 200, then the request failed
  if (response == null || response.statusCode != 200) {
    debugPrint('[EpisodeMapper] Request failed');
    onFailure?.call();
    return;
  }

  debugPrint('[EpisodeMapper] Request success');
  final episodes = stringToEpisodes(response.body);
  debugPrint('[EpisodeMapper] Episodes: ${episodes?.length}');

  // If episodes is null or empty, then the request failed
  if (episodes == null || episodes.isEmpty) {
    debugPrint('[EpisodeMapper] Conversion failed');
    onFailure?.call();
    return;
  }

  debugPrint('[EpisodeMapper] Conversion success');
  // Convert the episodes to widgets
  final widgets = episodesToWidgets(
    episodes,
    onUp: onUp,
    onDown: onDown,
  );

  // Remove the loader
  removeLoader();
  // Add widgets to the list
  list.addAll(widgets);
  // Call the onSuccess callback
  onSuccess?.call();
}
