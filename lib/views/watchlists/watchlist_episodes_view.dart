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
  GlobalKey _key = GlobalKey();
  bool _isLoading = true;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = isLoading;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildEpisodes({bool isNew = false}) async {
    await widget.watchlistMapper.watchlistEpisodeMapper.updateCurrentPage(
      onSuccess: () {
        if (isNew) {
          _key = GlobalKey();
        }

        _update(false);
      },
    );
  }

  void setOperation({bool isNew = false}) {
    _cancelableOperation?.cancel();
    _cancelableOperation =
        CancelableOperation.fromFuture(rebuildEpisodes(isNew: isNew));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setOperation(isNew: true));

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        widget.watchlistMapper.watchlistEpisodeMapper.currentPage++;
        widget.watchlistMapper.watchlistEpisodeMapper.addLoader();
        _update(true);
        setOperation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EpisodeList(
      key: _key,
      scrollController: _scrollController,
      children: widget.watchlistMapper.watchlistEpisodeMapper.list,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cancelableOperation?.cancel();
    _scrollController.dispose();
  }
}
