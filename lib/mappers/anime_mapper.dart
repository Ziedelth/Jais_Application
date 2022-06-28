import 'dart:convert';

import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/mappers/country_mapper.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/simulcast.dart';
import 'package:jais/utils/utils.dart';
import 'package:url/url.dart';

class AnimeMapper extends IMapper<Anime> {
  Simulcast? simulcast;

  AnimeMapper() : super(limit: 24, loaderWidget: const AnimeLoaderWidget());

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
  Future<void> updateCurrentPage() async {
    if (simulcast == null) return;
    addLoader();

    final response = await URL().get(
      'https://api.ziedelth.fr/v2/animes/country/${CountryMapper.selectedCountry?.tag}/simulcast/${simulcast?.id}/page/$currentPage/limit/$limit',
    );

    if (response == null || response.statusCode != 200) {
      return;
    }

    list.addAll(toWidgets(stringTo(fromBrotli(response.body))));
    removeLoader();
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

    return EpisodeMapper().stringTo(fromBrotli(response.body));
  }

  Future<void> __loadEpisodes(Anime anime) async {
    final episodes = await loadEpisodes(anime);

    if (episodes == null) {
      return;
    }

    anime.episodes.clear();
    anime.episodes.addAll(episodes);
  }

  Future<Anime?> loadDetails(
    Anime anime,
  ) async {
    await Future.wait([
      __loadEpisodes(anime),
    ]);

    return anime;
  }

  Future<List<AnimeWidget>?> search({
    required String query,
  }) async {
    final response = await URL().get(
      'https://api.ziedelth.fr/v2/animes/country/${CountryMapper.selectedCountry?.tag}/search/$query',
    );

    if (response == null || response.statusCode != 200) {
      return null;
    }

    return toWidgets(stringTo(fromBrotli(response.body)));
  }
}
