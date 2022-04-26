import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:jais/utils/utils.dart';

class WatchlistEpisodesView extends StatefulWidget {
  final WatchlistMapper watchlistMapper;

  const WatchlistEpisodesView(this.watchlistMapper, {Key? key}) : super(key: key);

  @override
  _WatchlistEpisodesViewState createState() => _WatchlistEpisodesViewState();
}

class _WatchlistEpisodesViewState extends State<WatchlistEpisodesView> {
  final _scrollController = ScrollController();
  bool _isLoading = true;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = false;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildEpisodes() async {
    await widget.watchlistMapper.updateEpisodesCurrentPage(
      onSuccess: () => _update(false),
      onFailure: () =>
          showSnackBar(context, 'An error occurred while loading episodes'),
    );
  }

  void setOperation() {
    _cancelableOperation?.cancel();
    _cancelableOperation = CancelableOperation.fromFuture(rebuildEpisodes());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => setOperation());

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
    return JList(
      controller: _scrollController,
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
