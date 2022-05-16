import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/watchlist_mapper.dart';

class WatchlistEpisodesView extends StatefulWidget {
  final WatchlistMapper watchlistMapper;

  const WatchlistEpisodesView(this.watchlistMapper, {Key? key})
      : super(key: key);

  @override
  _WatchlistEpisodesViewState createState() => _WatchlistEpisodesViewState();
}

class _WatchlistEpisodesViewState extends State<WatchlistEpisodesView> {
  final _scrollController = ScrollController();
  bool _isLoading = true;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = isLoading;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildEpisodes() async {
    await widget.watchlistMapper
        .updateEpisodesCurrentPage(onSuccess: () => _update(false));
  }

  void setOperation({bool isNew = false}) {
    _cancelableOperation?.cancel();
    _cancelableOperation = CancelableOperation.fromFuture(rebuildEpisodes());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setOperation(isNew: true));

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        widget.watchlistMapper.currentPageEpisodes++;
        widget.watchlistMapper.addEpisodeLoader();
        _update(true);
        setOperation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EpisodeList(
      scrollController: _scrollController,
      children: widget.watchlistMapper.episodesList,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cancelableOperation?.cancel();
    _scrollController.dispose();
  }
}
