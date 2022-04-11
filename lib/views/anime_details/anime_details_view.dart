import 'package:flutter/material.dart';
import 'package:jais/components/jtab.dart';
import 'package:jais/components/platform_widget.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/platform.dart';
import 'package:jais/views/anime_details/anime_details_header.dart';
import 'package:jais/views/anime_details/episodes_details_view.dart';
import 'package:jais/views/anime_details/scans_details_view.dart';

class AnimeDetailsView extends StatefulWidget {
  final Anime _anime;
  final VoidCallback _callback;

  const AnimeDetailsView(this._anime, this._callback);

  @override
  _AnimeDetailsViewState createState() => _AnimeDetailsViewState();
}

class _AnimeDetailsViewState extends State<AnimeDetailsView>
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

  List<Widget> buildWidgets() {
    final bool seasonsNotEmpty = widget._anime.episodes.map<int>((e) => e.season).toSet().isNotEmpty;
    final bool scansNotEmpty = widget._anime.scans.isNotEmpty;

    if (seasonsNotEmpty && scansNotEmpty) {
      return [
        JTab(_tabController),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              EpisodesDetailsView(widget._anime),
              ScansDetailsView(widget._anime),
            ],
          ),
        ),
      ];
    }

    return [
      if (seasonsNotEmpty)
        Expanded(
          child: EpisodesDetailsView(widget._anime),
        ),
      if (scansNotEmpty)
        Expanded(
          child: ScansDetailsView(widget._anime),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimeDetailsHeader(widget._callback, widget._anime),
        const Divider(
          height: 2,
        ),
        ...buildWidgets(),
      ],
    );
  }
}
