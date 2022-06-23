import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/views/anime_details/anime_details_header.dart';

class AnimeDetailsView extends StatefulWidget {
  final Anime _anime;

  const AnimeDetailsView(this._anime, {super.key});

  @override
  _AnimeDetailsViewState createState() => _AnimeDetailsViewState();
}

class _AnimeDetailsViewState extends State<AnimeDetailsView> {
  late final List<int> seasons;
  late final List<DropdownMenuItem<int>> _dropdownItems;
  List<Widget>? _episodes;
  int? _selectedSeason;

  void _changeSeason(int? newValue) => setState(() {
        _selectedSeason = newValue;
        _episodes = widget._anime.episodes
            .where((element) => element.season == newValue)
            .map<Widget>((element) => EpisodeWidget(episode: element))
            .toList();
      });

  @override
  void initState() {
    super.initState();
    seasons = widget._anime.episodes.map((e) => e.season).toSet().toList();

    if (seasons.isNotEmpty) {
      _selectedSeason = seasons.first;

      _dropdownItems = seasons
          .map<DropdownMenuItem<int>>(
            (e) => DropdownMenuItem(
              value: e,
              child: Text('${widget._anime.country.season} $e'),
            ),
          )
          .toList();

      _episodes = widget._anime.episodes
          .where((element) => element.season == _selectedSeason)
          .map<Widget>((element) => EpisodeWidget(episode: element))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimeDetailsHeader(widget._anime),
        const Divider(
          height: 2,
        ),
        Expanded(
          child: seasons.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      Text("Il n'y a pas d'épisodes pour cet anime"),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (seasons.length > 1)
                      DropdownButton<int>(
                        value: _selectedSeason,
                        onChanged: _changeSeason,
                        items: _dropdownItems,
                      ),
                    if (_episodes != null)
                      Expanded(
                        child: EpisodeList(
                          children: _episodes!,
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
