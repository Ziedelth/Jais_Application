import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/const.dart';

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
