import 'package:flutter/material.dart';
import 'package:jais/components/jtab.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:jais/views/watchlists/watchlist_episodes_view.dart';
import 'package:jais/views/watchlists/watchlist_scans_view.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({Key? key}) : super(key: key);

  @override
  _WatchlistViewState createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView>
    with SingleTickerProviderStateMixin {
  final _watchlistMapper = WatchlistMapper(pseudo: getPseudo()!);
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
              WatchlistEpisodesView(_watchlistMapper),
              WatchlistScansView(_watchlistMapper),
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
