import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/models/anime_details.dart';
import 'package:jais/models/season.dart';

class EpisodesDetailsView extends StatefulWidget {
  final AnimeDetails _animeDetails;

  EpisodesDetailsView(this._animeDetails);

  @override
  _EpisodesDetailsViewState createState() => _EpisodesDetailsViewState();
}

class _EpisodesDetailsViewState extends State<EpisodesDetailsView> {
  late final List<DropdownMenuItem<Season>> _dropdownItems;
  late final List<Widget> _episodes;

  Season? _selectedSeason;

  void _changeSeason(Season? newValue) =>
      setState(() => _selectedSeason = newValue);

  @override
  void initState() {
    if (widget._animeDetails.seasons.isNotEmpty) {
      _selectedSeason = widget._animeDetails.seasons.first;

      _dropdownItems = widget._animeDetails.seasons
          .map<DropdownMenuItem<Season>>(
            (e) => DropdownMenuItem(
              value: e,
              child: Text('Saison ${e.season}'),
            ),
          )
          .toList();

      _episodes = _selectedSeason!.episodes
          .map<Widget>(
            (element) => EpisodeWidget(episode: element),
          )
          .toList();
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
        if (widget._animeDetails.seasons.length > 1)
          DropdownButton<Season>(
            value: _selectedSeason,
            onChanged: _changeSeason,
            items: _dropdownItems,
          ),
        Expanded(
          child: JList(
            children: _episodes,
          ),
        ),
      ],
    );
  }
}
