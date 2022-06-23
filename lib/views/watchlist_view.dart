import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:provider/provider.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  _WatchlistViewState createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  final _watchlistMapper = WatchlistMapper(pseudo: getMember()!.pseudo);
  UniqueKey _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    _watchlistMapper.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _watchlistMapper.watchlistEpisodeMapper.updateCurrentPage();

      if (!mounted) return;
      setState(() => _key = UniqueKey());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ChangeNotifierProvider<WatchlistEpisodeMapper>.value(
        value: _watchlistMapper.watchlistEpisodeMapper,
        child: Consumer<WatchlistEpisodeMapper>(
          builder: (context, watchlistEpisodeMapper, _) {
            return EpisodeList(
              key: _key,
              scrollController: watchlistEpisodeMapper.scrollController,
              children: watchlistEpisodeMapper.list,
            );
          },
        ),
      ),
    );
  }
}
