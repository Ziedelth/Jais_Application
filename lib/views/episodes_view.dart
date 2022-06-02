import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:provider/provider.dart';

class EpisodesView extends StatefulWidget {
  const EpisodesView({super.key});

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  final _episodeMapper = EpisodeMapper();

  @override
  void initState() {
    super.initState();
    _episodeMapper.clear();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _episodeMapper.updateCurrentPage());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _episodeMapper.clear();
        _episodeMapper.updateCurrentPage();
      },
      child: ChangeNotifierProvider<EpisodeMapper>.value(
        value: _episodeMapper,
        child: Consumer<EpisodeMapper>(
          builder: (context, episodeMapper, _) {
            return EpisodeList(
              scrollController: episodeMapper.scrollController,
              children: episodeMapper.list,
            );
          },
        ),
      ),
    );
  }
}
