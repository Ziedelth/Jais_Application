import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:jais/mappers/scan_mapper.dart';
import 'package:jais/mappers/url_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/models/simulcast.dart';
import 'package:jais/utils/country.dart';

class AnimeMapper {
  static const _limit = 9;
  int currentPage = 1;
  List<Widget> list = _defaultList;

  static List<Widget> get _defaultList => List.filled(
        _limit,
        const AnimeLoaderWidget(),
        growable: true,
      );

  void clear() {
    currentPage = 1;
    list = _defaultList;
  }

  void addLoader() => list.addAll(_defaultList);

  void removeLoader() =>
      list.removeWhere((element) => element is AnimeLoaderWidget);

// Convert a String? to a List<Anime>?
  List<Anime>? stringToAnimes(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Anime.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

// Convert a List<Anime> to List<AnimeWidget>
  List<AnimeWidget> animesToWidgets(
    List<Anime> animes, {
    Function(Anime anime)? onUp,
    Function(Anime anime)? onDown,
  }) {
    return animes
        .map(
          (e) => AnimeWidget(
            anime: e,
            onUp: onUp,
            onDown: onDown,
          ),
        )
        .toList();
  }

// Update the list of animes
  Future<void> updateCurrentPage({
    required Simulcast simulcast,
    Function()? onSuccess,
    Function()? onFailure,
    Function(Anime anime)? onUp,
    Function(Anime anime)? onDown,
  }) async {
    final url =
        'v1/animes/country/${Country.name}/simulcast/${simulcast.id}/page/$currentPage/limit/$_limit';
    final urlMapper = URLMapper();
    debugPrint('[AnimeMapper] Fetching $url');
    final response = await urlMapper.getOwn(url);
    debugPrint('[AnimeMapper] Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      debugPrint('[AnimeMapper] Request failed');
      onFailure?.call();
      return;
    }

    debugPrint('[AnimeMapper] Request success');
    final animes = stringToAnimes(utf8.decode(response.bodyBytes));
    debugPrint('[AnimeMapper] Animes: ${animes?.length}');

    // If animes is null or empty, then the request failed
    if (animes == null || animes.isEmpty) {
      debugPrint('[AnimeMapper] Conversion failed');
      onFailure?.call();
      return;
    }

    debugPrint('[AnimeMapper] Conversion success');
    // Convert the animes to widgets
    final widgets = animesToWidgets(
      animes,
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

// Load episodes for an anime
  Future<List<Episode>?> loadEpisodes(
    EpisodeMapper episodeMapper,
    Anime anime,
  ) async {
    final url = 'v1/episodes/anime/${anime.id}';
    final urlMapper = URLMapper();
    debugPrint('[AnimeMapper] Fetching $url');
    final response = await urlMapper.getOwn(url);
    debugPrint('[AnimeMapper] Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      debugPrint('[AnimeMapper] Request failed');
      return null;
    }

    debugPrint('[AnimeMapper] Request success');
    final episodes =
        episodeMapper.stringToEpisodes(utf8.decode(response.bodyBytes));
    debugPrint('[AnimeMapper] Episodes: ${episodes?.length}');

    // If episodes is null or empty, then the request failed
    if (episodes == null) {
      debugPrint('[AnimeMapper] Conversion failed');
      return null;
    }

    debugPrint('[AnimeMapper] Conversion success');
    return episodes;
  }

// Load scans for an anime
  Future<List<Scan>?> loadScans(ScanMapper scanMapper, Anime anime) async {
    final url = 'v1/scans/anime/${anime.id}';
    final urlMapper = URLMapper();
    debugPrint('[AnimeMapper] Fetching $url');
    final response = await urlMapper.getOwn(url);
    debugPrint('[AnimeMapper] Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      debugPrint('[AnimeMapper] Request failed');
      return null;
    }

    debugPrint('[AnimeMapper] Request success');
    final scans = scanMapper.stringToScans(utf8.decode(response.bodyBytes));
    debugPrint('[AnimeMapper] Scans: ${scans?.length}');

    // If scans is null or empty, then the request failed
    if (scans == null) {
      debugPrint('[AnimeMapper] Conversion failed');
      return null;
    }

    debugPrint('[AnimeMapper] Conversion success');
    return scans;
  }

// Load details of a specific anime
  Future<Anime?> loadDetails(
    EpisodeMapper episodeMapper,
    ScanMapper scanMapper,
    Anime anime,
  ) async {
    final episodes = await loadEpisodes(episodeMapper, anime);

    // If episodes is null, then the request failed
    if (episodes == null) {
      debugPrint('[AnimeMapper] Episodes request failed');
      return null;
    }

    final scans = await loadScans(scanMapper, anime);

    // If scans is null, then the request failed
    if (scans == null) {
      debugPrint('[AnimeMapper] Scans request failed');
      return null;
    }

    anime.episodes.clear();
    anime.episodes.addAll(episodes);

    anime.scans.clear();
    anime.scans.addAll(scans);

    return anime;
  }

  Future<List<AnimeWidget>?> search({
    required String query,
  }) async {
    final url = 'v1/animes/country/${Country.name}/search/$query';
    final urlMapper = URLMapper();
    debugPrint('[AnimeMapper] Fetching $url');
    final response = await urlMapper.getOwn(url);
    debugPrint('[AnimeMapper] Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      debugPrint('[AnimeMapper] Request failed');
      return null;
    }

    debugPrint('[AnimeMapper] Request success');
    final animes = stringToAnimes(utf8.decode(response.bodyBytes));
    debugPrint('[AnimeMapper] Animes: ${animes?.length}');

    // If animes is null or empty, then the request failed
    if (animes == null || animes.isEmpty) {
      debugPrint('[AnimeMapper] Conversion failed');
      return null;
    }

    debugPrint('[AnimeMapper] Conversion success');
    // Convert the animes to widgets
    final widgets = animesToWidgets(animes);

    // Call the onSuccess callback
    return widgets;
  }
}
