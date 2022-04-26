import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:jais/utils/utils.dart';

class EpisodesView extends StatefulWidget {
  const EpisodesView({Key? key}) : super(key: key);

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  final _episodeMapper = EpisodeMapper();
  final _scrollController = ScrollController();
  final _key = GlobalKey();
  bool _isLoading = true;

  void _update(bool isLoading) {
    _isLoading = false;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildEpisodes() async {
    await _episodeMapper.updateCurrentPage(
      onSuccess: () => _update(false),
      onFailure: () =>
          showSnackBar(context, 'An error occurred while loading episodes'),
    );
  }

  @override
  void initState() {
    super.initState();
    _episodeMapper.clear();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await rebuildEpisodes();
      _update(false);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        _episodeMapper.currentPage++;
        _episodeMapper.addLoader();
        rebuildEpisodes();
        _update(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isOnMobile(context)) {
      return GridView(
        key: _key,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.125,
        ),
        controller: _scrollController,
        children: _episodeMapper.list,
      );
    }

    return JList(
      key: _key,
      controller: _scrollController,
      children: _episodeMapper.list,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _episodeMapper.clear();
  }
}
