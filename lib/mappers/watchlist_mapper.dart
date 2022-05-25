import 'dart:convert';

import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/components/scans/scan_loader_widget.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/decompress.dart';
import 'package:url/url.dart';

class WatchlistMapper {
  final String pseudo;
  final WatchlistEpisodeMapper watchlistEpisodeMapper;
  final WatchlistScanMapper watchlistScanMapper;

  WatchlistMapper({required this.pseudo})
      : watchlistEpisodeMapper = WatchlistEpisodeMapper(pseudo: pseudo),
        watchlistScanMapper = WatchlistScanMapper(pseudo: pseudo);

  void clear() {
    watchlistEpisodeMapper.clear();
    watchlistScanMapper.clear();
  }
}

class WatchlistEpisodeMapper extends IMapper<Episode> {
  final String pseudo;

  WatchlistEpisodeMapper({required this.pseudo})
      : super(limit: 12, loaderWidget: const EpisodeLoaderWidget());

  @override
  List<Episode> stringTo(String string) {
    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  List<EpisodeWidget> toWidgets(List<Episode> objects) {
    return objects.map((e) => EpisodeWidget(episode: e)).toList();
  }

  @override
  Future<void> updateCurrentPage({
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    final response = await URL().get(
      'https://api.ziedelth.fr/v2/watchlist/episodes/member/$pseudo/page/$currentPage/limit/$limit',
    );

    if (response == null || response.statusCode != 200) {
      onFailure?.call();
      return;
    }

    removeLoader();
    list.addAll(toWidgets(stringTo(fromBrotly(response.body))));
    onSuccess?.call();
  }
}

class WatchlistScanMapper extends IMapper<Scan> {
  final String pseudo;

  WatchlistScanMapper({required this.pseudo})
      : super(limit: 33, loaderWidget: const ScanLoaderWidget());

  @override
  List<Scan> stringTo(String string) {
    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Scan.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  List<ScanWidget> toWidgets(List<Scan> objects) {
    return objects.map((e) => ScanWidget(scan: e)).toList();
  }

  @override
  Future<void> updateCurrentPage({
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    final response = await URL().get(
      'https://api.ziedelth.fr/v2/watchlist/scans/member/$pseudo/page/$currentPage/limit/$limit',
    );

    if (response == null || response.statusCode != 200) {
      onFailure?.call();
      return;
    }

    removeLoader();
    list.addAll(toWidgets(stringTo(fromBrotly(response.body))));
    onSuccess?.call();
  }
}
