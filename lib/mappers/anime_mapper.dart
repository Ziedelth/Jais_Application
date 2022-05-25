import 'dart:convert';

import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/mappers/scan_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/models/simulcast.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/decompress.dart';
import 'package:url/url.dart';

class AnimeMapper extends IMapper<Anime> {
  Simulcast? simulcast;

  AnimeMapper() : super(limit: 18, loaderWidget: const AnimeLoaderWidget());

  @override
  List<Anime> stringTo(String string) {
    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Anime.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  List<AnimeWidget> toWidgets(List<Anime> objects) {
    return objects.map((e) => AnimeWidget(anime: e)).toList();
  }

  @override
  Future<void> updateCurrentPage({
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    if (simulcast == null) return;

    final response = await URL().get(
      'https://api.ziedelth.fr/v2/animes/country/${Country.name}/simulcast/${simulcast?.id}/page/$currentPage/limit/$limit',
    );

    if (response == null || response.statusCode != 200) {
      onFailure?.call();
      return;
    }

    removeLoader();
    list.addAll(toWidgets(stringTo(fromBrotly(response.body))));
    onSuccess?.call();
  }

  Future<List<Episode>?> loadEpisodes(
    Anime anime,
  ) async {
    final response = await URL().get(
      'https://api.ziedelth.fr/v2/episodes/anime/${anime.url}',
    );

    if (response == null || response.statusCode != 200) {
      return null;
    }

    return EpisodeMapper().stringTo(fromBrotly(response.body));
  }

  Future<List<Scan>?> loadScans(Anime anime) async {
    final response = await URL().get(
      'https://api.ziedelth.fr/v2/scans/anime/${anime.url}',
    );

    if (response == null || response.statusCode != 200) {
      return null;
    }

    return ScanMapper().stringTo(fromBrotly(response.body));
  }

  Future<void> __loadEpisodes(Anime anime) async {
    final episodes = await loadEpisodes(anime);

    if (episodes == null) {
      return;
    }

    anime.episodes.clear();
    anime.episodes.addAll(episodes);
  }

  Future<void> __loadScans(Anime anime) async {
    final scans = await loadScans(anime);

    if (scans == null) {
      return;
    }

    anime.scans.clear();
    anime.scans.addAll(scans);
  }

  Future<Anime?> loadDetails(
    Anime anime,
  ) async {
    await Future.wait([
      __loadEpisodes(anime),
      __loadScans(anime),
    ]);

    return anime;
  }

  Future<List<AnimeWidget>?> search({
    required String query,
  }) async {
    final response = await URL().get(
      'https://api.ziedelth.fr/v2/animes/country/${Country.name}/search/$query',
    );

    if (response == null || response.statusCode != 200) {
      return null;
    }

    return toWidgets(stringTo(fromBrotly(response.body)));
  }
}
