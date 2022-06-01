import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:provider/provider.dart';

class EpisodesView extends StatelessWidget {
  final _episodeMapper = EpisodeMapper();

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
