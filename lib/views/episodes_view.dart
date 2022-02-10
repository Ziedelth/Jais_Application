import 'package:flutter/material.dart';
import 'package:jais/utils/utils.dart';

class EpisodesView extends StatefulWidget {
  const EpisodesView({Key? key}) : super(key: key);

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  final ScrollController _scrollController = ScrollController();

  Future<void> rebuildEpisodes() async {
    await Utils.updateCurrentPageEpisodes(
      onSuccess: () => setState(() {}),
    );
  }

  @override
  void initState() {
    super.initState();

    Utils.clearEpisodes();
    rebuildEpisodes();

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0) {
        Utils.episodeCurrentPage++;
        Utils.addLoaderEpisodes();
        await rebuildEpisodes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: Utils.episodes.length,
      itemBuilder: (context, index) {
        return Utils.episodes[index];
      },
    );
  }
}
