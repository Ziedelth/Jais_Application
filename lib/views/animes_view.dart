import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/components/loading_widget.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/long_anime.dart';
import 'package:jais/models/season.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/utils/main_color.dart';
import 'package:jais/utils/utils.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({Key? key}) : super(key: key);

  @override
  _AnimesViewState createState() => _AnimesViewState();
}

class _AnimesViewState extends State<AnimesView> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _hasTap = false;
  LongAnime? _longAnime;

  @override
  void initState() {
    super.initState();

    AnimeMapper.clear();
    AnimeMapper.update(
      onSuccess: () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasTap && _longAnime != null) {
      return AnimeDetailsView(_longAnime!, () {
        setState(() {
          _hasTap = false;
          _longAnime = null;
        });
      });
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(label: Text('Rechercher')),
                  onChanged: (value) => setState(
                    () => AnimeMapper.onSearch(value),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: MainColor.mainColorO,
                ),
                onPressed: () => setState(
                  () => AnimeMapper.onSearch(_textEditingController.text),
                ),
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Expanded(
          child: ListView.builder(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemCount: AnimeMapper.filtered.length,
            itemBuilder: (context, index) {
              final Widget widget = AnimeMapper.filtered[index];

              if (widget is! AnimeWidget) {
                return widget;
              }

              final Anime anime = widget.anime;

              return GestureDetector(
                child: widget,
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const Center(
                      child: Loading(),
                    ),
                  );

                  Utils.request(
                    'https://ziedelth.fr/api/v1/country/fr/anime/${anime.id}',
                        (p0) {
                      _longAnime = LongAnime.fromJson(jsonDecode(p0));
                      _hasTap = true;
                      Navigator.pop(context);
                      setState(() {});
                    },
                        (p0) => null,
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}

class AnimeDetailsView extends StatefulWidget {
  final LongAnime _longAnime;
  final VoidCallback _callback;

  AnimeDetailsView(this._longAnime, this._callback);

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
    if (widget._longAnime.seasons.isNotEmpty &&
        widget._longAnime.scans.isNotEmpty) {
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
              EpisodesDetailsView(widget._longAnime),
              ScansDetailsView(widget._longAnime),
            ],
          ),
        ),
      ];
    }

    if (widget._longAnime.seasons.isNotEmpty) {
      return [
        Expanded(
          child: EpisodesDetailsView(widget._longAnime),
        ),
      ];
    }

    if (widget._longAnime.scans.isNotEmpty) {
      return [
        Expanded(
          child: ScansDetailsView(widget._longAnime),
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
                      widget._longAnime.name,
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
                                    widget._longAnime.genres,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Divider(
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(widget._longAnime.description ??
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
  final LongAnime _longAnime;

  EpisodesDetailsView(this._longAnime);

  @override
  _EpisodesDetailsViewState createState() => _EpisodesDetailsViewState();
}

class _EpisodesDetailsViewState extends State<EpisodesDetailsView> {
  Season? _selectedSeason;

  @override
  void initState() {
    if (widget._longAnime.seasons.isNotEmpty) {
      _selectedSeason = widget._longAnime.seasons.first;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._longAnime.seasons.isEmpty) {
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
          items: widget._longAnime.seasons
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
  final LongAnime _longAnime;

  ScansDetailsView(this._longAnime);

  @override
  Widget build(BuildContext context) {
    if (_longAnime.scans.isEmpty) {
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
            itemCount: _longAnime.scans.length,
            itemBuilder: (context, index) => ScanWidget(
              scan: _longAnime.scans[index],
            ),
          ),
        ),
      ],
    );
  }
}
