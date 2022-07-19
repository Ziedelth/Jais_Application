import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/const.dart';

class EpisodeMapper extends IMapper<Episode> {
  EpisodeMapper()
      : super(
          limit: 12,
          loaderWidget: EpisodeLoaderWidget(),
          fromJson: Episode.fromJson,
          toWidget: (episode) => EpisodeWidget(episode: episode),
        ) {
    notifyListeners();
  }

  @override
  Future<void> updateCurrentPage() async =>
      loadPage(getEpisodesUrl(currentPage, limit));
}
