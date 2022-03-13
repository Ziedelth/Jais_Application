import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/models/anime_details.dart';
import 'package:jais/models/season.dart';
import 'package:jais/utils/main_color.dart';

class AnimeDetailsView extends StatefulWidget {
  final AnimeDetails _animeDetails;
  final VoidCallback _callback;

  AnimeDetailsView(this._animeDetails, this._callback);

  @override
  _AnimeDetailsViewState createState() => _AnimeDetailsViewState();
}

class _AnimeDetailsViewState extends State<AnimeDetailsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _notifications = false;

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
    if (widget._animeDetails.seasons.isNotEmpty &&
        widget._animeDetails.scans.isNotEmpty) {
      return [
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: MainColor.mainColorO,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            Tab(
              icon: const Icon(
                Icons.airplay,
              ),
            ),
            Tab(
              icon: const Icon(
                Icons.bookmark_border,
              ),
            )
          ],
        ),
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

    if (widget._animeDetails.seasons.isNotEmpty) {
      return [
        Expanded(
          child: EpisodesDetailsView(widget._animeDetails),
        ),
      ];
    }

    if (widget._animeDetails.scans.isNotEmpty) {
      return [
        Expanded(
          child: ScansDetailsView(widget._animeDetails),
        ),
      ];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            BackButton(
              onPressed: () => widget._callback(),
            ),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget._animeDetails.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(
                      icon: Icon(Icons.help),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: MainColor.mainColorO),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    widget._animeDetails.genres,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Divider(
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(widget._animeDetails.description ??
                                      'No description'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(
                  _notifications
                      ? Icons.notifications_on
                      : Icons.notifications_off,
                  color: _notifications ? Colors.green : Colors.red,
                ),
                onPressed: () {
                  _notifications = !_notifications;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        const Divider(
          height: 2,
        ),
        ...buildWidgets(),
      ],
    );
  }
}

class EpisodesDetailsView extends StatefulWidget {
  final AnimeDetails _animeDetails;

  EpisodesDetailsView(this._animeDetails);

  @override
  _EpisodesDetailsViewState createState() => _EpisodesDetailsViewState();
}

class _EpisodesDetailsViewState extends State<EpisodesDetailsView> {
  Season? _selectedSeason;

  @override
  void initState() {
    if (widget._animeDetails.seasons.isNotEmpty) {
      _selectedSeason = widget._animeDetails.seasons.first;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._animeDetails.seasons.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.close,
              color: Colors.red,
            ),
            Text("Il n'y a pas d'épisodes pour cet anime"),
          ],
        ),
      );
    }

    return Column(
      children: [
        DropdownButton<Season>(
          value: _selectedSeason,
          onChanged: (Season? newValue) {
            _selectedSeason = newValue;
            setState(() {});
          },
          items: widget._animeDetails.seasons
              .map<DropdownMenuItem<Season>>(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text('Saison ${e.season}'),
                ),
              )
              .toList(),
        ),
        Expanded(
          child: ListView.builder(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            controller: ScrollController(),
            itemCount: _selectedSeason!.episodes.length,
            itemBuilder: (context, index) => EpisodeWidget(
              episode: _selectedSeason!.episodes[index],
            ),
          ),
        ),
      ],
    );
  }
}

class ScansDetailsView extends StatelessWidget {
  final AnimeDetails _animeDetails;

  ScansDetailsView(this._animeDetails);

  @override
  Widget build(BuildContext context) {
    if (_animeDetails.scans.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.close,
              color: Colors.red,
            ),
            Text("Il n'y a pas de scans pour cet anime"),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            controller: ScrollController(),
            itemCount: _animeDetails.scans.length,
            itemBuilder: (context, index) => ScanWidget(
              scan: _animeDetails.scans[index],
            ),
          ),
        ),
      ],
    );
  }
}
