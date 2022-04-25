import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/components/jtab.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:jais/utils/utils.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({Key? key}) : super(key: key);

  @override
  _WatchlistViewState createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView>
    with SingleTickerProviderStateMixin {
  final _watchlistMapper = WatchlistMapper(pseudo: getPseudo()!);
  late final TabController _tabController;
  final _episodesScrollController = ScrollController();
  final _scansScrollController = ScrollController();
  bool _isLoading = true;

  void _update(bool isLoading) {
    _isLoading = false;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildEpisodes() async {
    await _watchlistMapper.updateEpisodesCurrentPage(
      onSuccess: () => _update(false),
      onFailure: () =>
          showSnackBar(context, 'An error occurred while loading episodes'),
    );
  }

  Future<void> rebuildScans() async {
    await _watchlistMapper.updateScansCurrentPage(
      onSuccess: () => _update(false),
      onFailure: () =>
          showSnackBar(context, 'An error occurred while loading scans'),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => _watchlistMapper.clear());
    _watchlistMapper.clear();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await rebuildEpisodes();
      await rebuildScans();
      _update(false);
    });

    _episodesScrollController.addListener(() {
      if (_episodesScrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        _watchlistMapper.currentPageEpisodes++;
        _watchlistMapper.addEpisodeLoader();
        rebuildEpisodes();
        _update(true);
      }
    });

    _scansScrollController.addListener(() {
      if (_scansScrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        _watchlistMapper.currentPageScans++;
        _watchlistMapper.addScanLoader();
        rebuildScans();
        _update(true);
      }
    });
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
              JList(
                controller: _episodesScrollController,
                children: _watchlistMapper.episodesList,
              ),
              JList(
                controller: _scansScrollController,
                children: _watchlistMapper.scansList,
              ),
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
    _episodesScrollController.dispose();
    _scansScrollController.dispose();
  }
}
