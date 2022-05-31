import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:provider/provider.dart';

class WatchlistEpisodesView extends StatefulWidget {
  final WatchlistMapper watchlistMapper;

  const WatchlistEpisodesView(this.watchlistMapper, {Key? key})
      : super(key: key);

  @override
  _WatchlistEpisodesViewState createState() => _WatchlistEpisodesViewState();
}

class _WatchlistEpisodesViewState extends State<WatchlistEpisodesView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        widget.watchlistMapper.watchlistEpisodeMapper.updateCurrentPage());

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0) {
        widget.watchlistMapper.watchlistEpisodeMapper.currentPage++;
        widget.watchlistMapper.watchlistEpisodeMapper.addLoader();
        widget.watchlistMapper.watchlistEpisodeMapper.updateCurrentPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WatchlistEpisodeMapper>.value(
      value: widget.watchlistMapper.watchlistEpisodeMapper,
      child: Consumer<WatchlistEpisodeMapper>(
        builder: (context, watchlistEpisodeMapper, _) {
          return EpisodeList(
            scrollController: _scrollController,
            children: watchlistEpisodeMapper.list,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
