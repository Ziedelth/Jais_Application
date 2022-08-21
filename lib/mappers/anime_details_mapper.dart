import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/const.dart';

class AnimeDetailsMapper extends IMapper<Episode> {
  final Anime anime;

  AnimeDetailsMapper(this.anime)
      : super(
          limit: 12,
          loaderWidget: const EpisodeLoaderWidget(),
          fromJson: Episode.fromJson,
          toWidget: (episode) => EpisodeWidget(episode: episode),
        ) {
    notifyListeners();
  }

  @override
  Future<void> updateCurrentPage() async {
    if (anime.url == null) return;
    await loadPage(getAnimeDetailsUrl(anime.url, currentPage, limit));
  }
}
