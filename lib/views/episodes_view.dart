import 'package:flutter/material.dart';
import 'package:jais/utils/episode_mapper.dart';

class EpisodesView extends StatefulWidget {
  const EpisodesView({Key? key}) : super(key: key);

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  Future<void> rebuildEpisodes() async {
    await EpisodeMapper.updateCurrentPage(
      onSuccess: () => setState(() {
        _isLoading = false;
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    EpisodeMapper.clear();
    rebuildEpisodes();

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        EpisodeMapper.currentPage++;
        EpisodeMapper.addLoader();
        setState(() {});
        await rebuildEpisodes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: EpisodeMapper.list.length,
      itemBuilder: (context, index) {
        return EpisodeMapper.list[index];
      },
    );
  }
}
