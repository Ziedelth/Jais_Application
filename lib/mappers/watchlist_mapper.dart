import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/scans/scan_loader_widget.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:jais/mappers/scan_mapper.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

class WatchlistMapper {
  final String pseudo;
  int currentPageEpisodes = 1;
  int currentPageScans = 1;
  List<Widget> episodesList = _defaultEpisodesList;
  List<Widget> scansList = _defaultScansList;

  WatchlistMapper({required this.pseudo});

  static List<Widget> get _defaultEpisodesList => List.filled(
        EpisodeMapper.limit,
        const EpisodeLoaderWidget(),
        growable: true,
      );

  static List<Widget> get _defaultScansList => List.filled(
        ScanMapper.limit,
        const ScanLoaderWidget(),
        growable: true,
      );

  void clear() {
    currentPageEpisodes = currentPageScans = 1;
    episodesList = _defaultEpisodesList;
    scansList = _defaultScansList;
  }

  void addEpisodeLoader() => episodesList.addAll(_defaultEpisodesList);

  void removeEpisodeLoader() =>
      episodesList.removeWhere((element) => element is EpisodeLoaderWidget);

  Future<void> updateEpisodesCurrentPage({
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    final link =
        'https://api.ziedelth.fr/v1/watchlist/episodes/member/$pseudo/page/$currentPageEpisodes/limit/${EpisodeMapper.limit}';
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
    final episodes =
        EpisodeMapper.stringToEpisodes(utf8.decode(response.bodyBytes));

    // If episodes is null or empty, then the request failed
    if (episodes == null) {
      logger.warning('Failed to convert in episodes list');
      onFailure?.call();
      return;
    }

    logger.info('Successfully converted in episodes list');
    // Convert the episodes to widgets
    final widgets = EpisodeMapper.episodesToWidgets(episodes);

    // Remove the loader
    removeEpisodeLoader();
    // Add widgets to the list
    episodesList.addAll(widgets);
    // Call the onSuccess callback
    onSuccess?.call();
  }

  void addScanLoader() => scansList.addAll(_defaultScansList);

  void removeScanLoader() =>
      scansList.removeWhere((element) => element is ScanLoaderWidget);

  Future<void> updateScansCurrentPage({
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    final link =
        'https://api.ziedelth.fr/v1/watchlist/scans/member/$pseudo/page/$currentPageScans/limit/${ScanMapper.limit}';
    final url = URL();
    logger.info('Fetching $link');
    final response = await url.get(link);
    logger.info('Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      logger.warning('Failed to fetch scans');
      onFailure?.call();
      return;
    }

    logger.info('Successfully fetched episodes');
    final scans = ScanMapper.stringToScans(utf8.decode(response.bodyBytes));

    // If scans is null or empty, then the request failed
    if (scans == null) {
      logger.warning('Failed to convert in scans list');
      onFailure?.call();
      return;
    }

    logger.info('Successfully converted in scans list');
    // Convert the scans to widgets
    final widgets = ScanMapper.scansToWidgets(scans);

    // Remove the loader
    removeScanLoader();
    // Add widgets to the list
    scansList.addAll(widgets);
    // Call the onSuccess callback
    onSuccess?.call();
  }
}
