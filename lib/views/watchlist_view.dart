import 'package:flutter/material.dart';
import 'package:jais/components/jtab.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({Key? key}) : super(key: key);

  @override
  _WatchlistViewState createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
              Container(),
              Container(),
              // EpisodesDetailsView(widget._anime),
              // ScansDetailsView(widget._anime),
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
