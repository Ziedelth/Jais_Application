import 'dart:convert';

import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/lang_type.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url/url.dart';

class WatchlistMapper extends IMapper<Episode> {
  final String pseudo;

  WatchlistMapper({required this.pseudo})
      : super(limit: 21, loaderWidget: EpisodeLoaderWidget());

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
    addLoader();

    final response =
        await URL().get(getWatchlistEpisodesUrl(pseudo, currentPage, limit));

    if (response == null || response.statusCode != 200) {
      return;
    }

    list.addAll(toWidgets(stringTo(fromBrotli(response.body))));
    removeLoader();
  }

  static const _filterKey = "langTypesFilter";

  Future<List<String>> getLangTypesFilter() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.containsKey(_filterKey)
        ? sharedPreferences.getStringList(_filterKey)!
        : [];
  }

  Future<void> setLangTypesFilter(List<String> langTypes) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(_filterKey, langTypes);
  }

  Future<void> addLangTypeFilter(LangType langType) async {
    final langTypes = await getLangTypesFilter();
    langTypes.add(langType.name);
    await setLangTypesFilter(langTypes);
  }

  Future<void> removeLangTypeFilter(LangType langType) async {
    final langTypes = await getLangTypesFilter();
    langTypes.remove(langType.name);
    await setLangTypesFilter(langTypes);
  }
}
