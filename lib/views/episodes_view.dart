import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:provider/provider.dart';

class EpisodesView extends StatefulWidget {
  const EpisodesView({Key? key}) : super(key: key);

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  final _episodeMapper = EpisodeMapper();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _episodeMapper.clear();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _episodeMapper.updateCurrentPage());

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0) {
        _episodeMapper.currentPage++;
        _episodeMapper.updateCurrentPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _episodeMapper.clear();
        await _episodeMapper.updateCurrentPage();
      },
      child: ChangeNotifierProvider<EpisodeMapper>(
        create: (_) => _episodeMapper,
        child: Consumer<EpisodeMapper>(
          builder: (context, episodeMapper, _) {
            return EpisodeList(
              scrollController: _scrollController,
              children: _episodeMapper.list,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _episodeMapper.dispose();
  }
}
