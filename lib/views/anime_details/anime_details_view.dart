import 'package:flutter/material.dart';
import 'package:jais/components/jtab.dart';
import 'package:jais/models/anime_details.dart';
import 'package:jais/views/anime_details/anime_details_header.dart';
import 'package:jais/views/anime_details/episodes_details_view.dart';
import 'package:jais/views/anime_details/scans_details_view.dart';

class AnimeDetailsView extends StatefulWidget {
  final AnimeDetails _animeDetails;
  final VoidCallback _callback;

  const AnimeDetailsView(this._animeDetails, this._callback);

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
    final bool seasonsNotEmpty = widget._animeDetails.seasons.isNotEmpty;
    final bool scansNotEmpty = widget._animeDetails.scans.isNotEmpty;

    if (seasonsNotEmpty && scansNotEmpty) {
      return [
        JTab(_tabController),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              EpisodesDetailsView(widget._animeDetails),
              ScansDetailsView(widget._animeDetails),
            ],
          ),
        ),
      ];
    }

    return [
      if (seasonsNotEmpty)
        Expanded(
          child: EpisodesDetailsView(widget._animeDetails),
        ),
      if (scansNotEmpty)
        Expanded(
          child: ScansDetailsView(widget._animeDetails),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimeDetailsHeader(widget._callback, widget._animeDetails),
        const Divider(
          height: 2,
        ),
        ...buildWidgets(),
      ],
    );
  }
}
