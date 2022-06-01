import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:provider/provider.dart';

class WatchlistEpisodesView extends StatelessWidget {
  final WatchlistEpisodeMapper watchlistEpisodeMapper;

  const WatchlistEpisodesView(this.watchlistEpisodeMapper, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WatchlistEpisodeMapper>.value(
      value: watchlistEpisodeMapper,
      child: Consumer<WatchlistEpisodeMapper>(
        builder: (context, watchlistEpisodeMapper, _) {
          return EpisodeList(
            scrollController: watchlistEpisodeMapper.scrollController,
            children: watchlistEpisodeMapper.list,
          );
        },
      ),
    );
  }
}
