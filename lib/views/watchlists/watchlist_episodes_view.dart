import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:provider/provider.dart';

class WatchlistEpisodesView extends StatefulWidget {
  final WatchlistEpisodeMapper watchlistEpisodeMapper;

  const WatchlistEpisodesView(this.watchlistEpisodeMapper, {super.key});

  @override
  _WatchlistEpisodesViewState createState() => _WatchlistEpisodesViewState();
}

class _WatchlistEpisodesViewState extends State<WatchlistEpisodesView> {
  @override
  void initState() {
    super.initState();
    widget.watchlistEpisodeMapper.clear();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.watchlistEpisodeMapper.updateCurrentPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WatchlistEpisodeMapper>.value(
      value: widget.watchlistEpisodeMapper,
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
