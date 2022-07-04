import 'dart:convert';

import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/simulcast.dart';
import 'package:jais/utils/const.dart';
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

    final response =
        await URL().get(getAnimesUrl(simulcast, currentPage, limit));

    if (response == null || response.statusCode != 200) {
      return;
    }

    list.addAll(toWidgets(stringTo(fromBrotli(response.body))));
    removeLoader();
  }

  Future<void> loadEpisodes(
    Anime anime,
  ) async {
    final response = await URL().get(getAnimeDetailsUrl(anime.url));

    if (response == null || response.statusCode != 200) {
      return;
    }

    final episodes = EpisodeMapper().stringTo(fromBrotli(response.body));

    anime.episodes.clear();
    anime.episodes.addAll(episodes);
  }

  Future<Anime?> loadDetails(
    Anime anime,
  ) async {
    await Future.wait([
      loadEpisodes(anime),
    ]);

    return anime;
  }

  Future<List<AnimeWidget>?> search({
    required String query,
  }) async {
    final response = await URL().get(getAnimesSearchUrl(query));

    if (response == null || response.statusCode != 200) {
      return null;
    }

    return toWidgets(stringTo(fromBrotli(response.body)));
  }
}
