import 'package:flutter/material.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/episodes_view.dart';
import 'package:jais/views/scans_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Utils.getTabBar(_tabController),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const EpisodesView(),
              const ScansView(),
            ],
          ),
        ),
      ],
    );
  }
}
