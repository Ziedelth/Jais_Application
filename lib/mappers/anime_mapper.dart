import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:jais/mappers/scan_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/models/simulcast.dart';
import 'package:jais/utils/country.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

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
    final link =
        'https://api.ziedelth.fr/v1/animes/country/${Country.name}/simulcast/${simulcast.id}/page/$currentPage/limit/$_limit';
    final url = URL();
    logger.info('Fetching $link');
    final response = await url.get(link);
    logger.info('Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      logger.warning('Failed to fetch $link');
      onFailure?.call();
      return;
    }

    logger.info('Successfully fetched $link');
    final animes = stringToAnimes(utf8.decode(response.bodyBytes));
    logger.info('Animes: $animes');

    // If animes is null or empty, then the request failed
    if (animes == null) {
      logger.warning('Failed to convert in animes list');
      onFailure?.call();
      return;
    }

    logger.info('Successfully converted in animes list');
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
    Anime anime,
  ) async {
    final link = 'https://api.ziedelth.fr/v1/episodes/anime/${anime.url}';
    final url = URL();
    logger.info('Fetching $link');
    final response = await url.get(link);
    logger.info('Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      logger.warning('Failed to fetch $link');
      return null;
    }

    logger.info('Successfully fetched $link');
    final episodes =
        EpisodeMapper.stringToEpisodes(utf8.decode(response.bodyBytes));
    logger.info('Episodes: $episodes');

    // If episodes is null or empty, then the request failed
    if (episodes == null) {
      logger.warning('Failed to convert in episodes list');
      return null;
    }

    logger.info('Successfully converted in episodes list');
    return episodes;
  }

// Load scans for an anime
  Future<List<Scan>?> loadScans(Anime anime) async {
    final link = 'https://api.ziedelth.fr/v1/scans/anime/${anime.url}';
    final url = URL();
    logger.info('Fetching $link');
    final response = await url.get(link);
    logger.info('Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      logger.warning('Failed to fetch $link');
      return null;
    }

    logger.info('Successfully fetched $link');
    final scans = ScanMapper.stringToScans(utf8.decode(response.bodyBytes));
    logger.info('Scans: $scans');

    // If scans is null or empty, then the request failed
    if (scans == null) {
      logger.warning('Failed to convert in scans list');
      return null;
    }

    logger.info('Successfully converted in scans list');
    return scans;
  }

  Future<void> __loadEpisodes(Anime anime) async {
    logger.info('Loading episodes');
    final episodes = await loadEpisodes(anime);

    // If episodes is null, then the request failed
    if (episodes == null) {
      logger.warning('Failed to load episodes');
      return;
    }

    logger.info('Successfully loaded episodes');
    anime.episodes.clear();
    anime.episodes.addAll(episodes);
  }

  Future<void> __loadScans(Anime anime) async {
    logger.info('Loading scans');
    final scans = await loadScans(anime);

    // If scans is null, then the request failed
    if (scans == null) {
      logger.warning('Failed to load scans');
      return;
    }

    logger.info('Successfully loaded scans');
    anime.scans.clear();
    anime.scans.addAll(scans);
  }

// Load details of a specific anime
  Future<Anime?> loadDetails(
    Anime anime,
  ) async {
    logger.info('Loading details of ${anime.url}');

    await Future.wait([
      __loadEpisodes(anime),
      __loadScans(anime),
    ]);

    logger.info('Successfully loaded details of ${anime.url}');
    return anime;
  }

  Future<List<AnimeWidget>?> search({
    required String query,
  }) async {
    final link =
        'https://api.ziedelth.fr/v1/animes/country/${Country.name}/search/$query';
    final url = URL();
    logger.info('Fetching $link');
    final response = await url.get(link);
    logger.info('Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      logger.warning('Failed to fetch $link');
      return null;
    }

    logger.info('Successfully fetched $link');
    final animes = stringToAnimes(utf8.decode(response.bodyBytes));
    logger.info('Animes: $animes');

    // If animes is null or empty, then the request failed
    if (animes == null) {
      logger.warning('Failed to convert in animes list');
      return null;
    }

    logger.info('Successfully converted in animes list');
    // Convert the animes to widgets
    final widgets = animesToWidgets(animes);

    // Call the onSuccess callback
    return widgets;
  }
}
