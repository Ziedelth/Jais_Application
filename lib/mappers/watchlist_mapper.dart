import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/episode.dart';
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
}

class WatchlistFilter {
  final String key;

  WatchlistFilter({required this.key});

  Future<List<String>> getFilter() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.containsKey(key)
        ? sharedPreferences.getStringList(key)!
        : [];
  }

  Future<void> setFilter(List<String> filter) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(key, filter);
  }

  Future<void> addToFilter(String string) async {
    final filter = await getFilter();
    filter.add(string);
    await setFilter(filter);
  }

  Future<void> removeToFilter(String string) async {
    final filter = await getFilter();
    filter.remove(string);
    await setFilter(filter);
  }
}

class WatchlistLangTypeFilter extends WatchlistFilter {
  WatchlistLangTypeFilter() : super(key: "langTypesFilter");
}
