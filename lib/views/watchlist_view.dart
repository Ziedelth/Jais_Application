import 'package:flutter/material.dart';
import 'package:jais/components/jtab.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:jais/views/watchlists/watchlist_episodes_view.dart';
import 'package:jais/views/watchlists/watchlist_scans_view.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  _WatchlistViewState createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView>
    with SingleTickerProviderStateMixin {
  final _watchlistMapper = WatchlistMapper(pseudo: getMember()!.pseudo);
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _watchlistMapper.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        JTab(_tabController),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              WatchlistEpisodesView(_watchlistMapper.watchlistEpisodeMapper),
              WatchlistScansView(_watchlistMapper.watchlistScanMapper),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
