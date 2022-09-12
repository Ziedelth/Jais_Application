import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  final _watchlistMapper =
      WatchlistMapper(pseudo: MemberMapper.instance.getMember()!.pseudo);
  UniqueKey _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    Logger.info('Initializing watchlist view...');
    _watchlistMapper.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Logger.info('Loading watchlist...');
      await _watchlistMapper.updateCurrentPage();
      Logger.debug('Watchlist length: ${_watchlistMapper.list.length}');

      if (!mounted) return;
      setState(() => _key = UniqueKey());
    });

    Logger.info('Watchlist view initialized.');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WatchlistMapper>.value(
      value: _watchlistMapper,
      child: Consumer<WatchlistMapper>(
        builder: (context, watchlistMapper, _) => EpisodeList(
          key: _key,
          scrollController: watchlistMapper.scrollController,
          children: watchlistMapper.list,
        ),
      ),
    );
  }
}
