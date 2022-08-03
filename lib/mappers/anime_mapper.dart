import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/simulcast.dart';
import 'package:jais/utils/const.dart';
import 'package:url/url.dart';

class AnimeMapper extends IMapper<Anime> {
  Simulcast? simulcast;

  AnimeMapper()
      : super(
          limit: 24,
          loaderWidget: const AnimeLoaderWidget(),
          fromJson: Anime.fromJson,
          toWidget: (anime) => AnimeWidget(anime: anime),
        );

  @override
  Future<void> updateCurrentPage() async {
    if (simulcast == null) return;
    await loadPage(getAnimesUrl(simulcast, currentPage, limit));
  }

  Future<List<Widget>?> search({
    required String query,
  }) async {
    final response = await URL().get(getAnimesSearchUrl(query));

    if (response == null || response.statusCode != 200) {
      return null;
    }

    return toWidgets(response.body);
  }
}
