import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/models/anime.dart';

class EpisodesDetailsView extends StatefulWidget {
  final Anime _anime;

  const EpisodesDetailsView(this._anime, {super.key});

  @override
  _EpisodesDetailsViewState createState() => _EpisodesDetailsViewState();
}

class _EpisodesDetailsViewState extends State<EpisodesDetailsView> {
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) {
      return Center(
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
      );
    }

    return Column(
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
    );
  }
}
