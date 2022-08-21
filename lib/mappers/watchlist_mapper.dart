import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/lang_type.dart';
import 'package:jais/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistMapper extends IMapper<Episode> {
  final String pseudo;

  WatchlistMapper({required this.pseudo})
      : super(
          limit: 21,
          loaderWidget: const EpisodeLoaderWidget(),
          fromJson: Episode.fromJson,
          toWidget: (episode) => EpisodeWidget(episode: episode),
        );

  @override
  Future<void> updateCurrentPage() async =>
      loadPage(getWatchlistEpisodesUrl(pseudo, currentPage, limit));

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
