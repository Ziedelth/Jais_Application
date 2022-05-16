import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/episode_mapper.dart';

class EpisodesView extends StatefulWidget {
  const EpisodesView({Key? key}) : super(key: key);

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  final _episodeMapper = EpisodeMapper();
  final _scrollController = ScrollController();
  bool _isLoading = true;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = isLoading;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildEpisodes() async {
    await _episodeMapper.updateCurrentPage(onSuccess: () => _update(false));
  }

  void setOperation() {
    _cancelableOperation?.cancel();
    _cancelableOperation = CancelableOperation.fromFuture(rebuildEpisodes());
  }

  @override
  void initState() {
    super.initState();
    _episodeMapper.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => setOperation());

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        _episodeMapper.currentPage++;
        _episodeMapper.addLoader();
        _update(true);
        setOperation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _episodeMapper.clear();
        _update(true);
        setOperation();
      },
      child: EpisodeList(
        scrollController: _scrollController,
        children: _episodeMapper.list,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cancelableOperation?.cancel();
    _scrollController.dispose();
    _episodeMapper.clear();
  }
}
