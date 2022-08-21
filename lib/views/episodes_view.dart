import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EpisodesView extends StatefulWidget {
  const EpisodesView({super.key});

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  final _episodeMapper = EpisodeMapper();
  UniqueKey _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    Logger.info('Initializing episodes view...');

    _episodeMapper.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Logger.info('Loading episodes...');
      await _episodeMapper.updateCurrentPage();
      Logger.debug('Episodes length: ${_episodeMapper.list.length}');

      if (!mounted) return;
      setState(() => _key = UniqueKey());
    });

    Logger.info('Episodes view initialized.');
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Logger.info('Refreshing episodes...');
        _episodeMapper.clear();
        Logger.info('Loading episodes...');
        _episodeMapper.updateCurrentPage();
        Logger.debug('Episodes length: ${_episodeMapper.list.length}');
        Logger.info('Episodes refreshed.');
      },
      child: ChangeNotifierProvider<EpisodeMapper>.value(
        value: _episodeMapper,
        child: Consumer<EpisodeMapper>(
          builder: (context, episodeMapper, _) {
            return EpisodeList(
              key: _key,
              scrollController: _episodeMapper.scrollController,
              children: episodeMapper.list,
            );
          },
        ),
      ),
    );
  }
}
