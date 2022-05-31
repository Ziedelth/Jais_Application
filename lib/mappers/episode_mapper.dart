import 'dart:convert';

import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/decompress.dart';
import 'package:url/url.dart';

class EpisodeMapper extends IMapper<Episode> {
  EpisodeMapper() : super(limit: 12, loaderWidget: const EpisodeLoaderWidget()) {
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
  Future<void> updateCurrentPage({
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    addLoader();

    final response = await URL().get(
      'https://api.ziedelth.fr/v2/episodes/country/${Country.name}/page/$currentPage/limit/$limit',
    );

    if (response == null || response.statusCode != 200) {
      return;
    }

    list.addAll(toWidgets(stringTo(fromBrotly(response.body))));
    removeLoader();
  }
}
