import 'dart:convert';

import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:url/url.dart';

class AnimeDetailsMapper extends IMapper<Episode> {
  Anime anime;

  AnimeDetailsMapper(this.anime)
      : super(limit: 12, loaderWidget: EpisodeLoaderWidget()) {
    notifyListeners();
  }

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
  Future<void> updateCurrentPage() async {
    if (anime.url == null) {
      return;
    }

    addLoader();

    final response =
        await URL().get(getAnimeDetailsUrl(anime.url, currentPage, limit));

    if (response == null || response.statusCode != 200) {
      return;
    }

    list.addAll(toWidgets(stringTo(fromBrotli(response.body))));
    removeLoader();
  }
}
