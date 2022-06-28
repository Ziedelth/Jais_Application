import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/components/jdialog.dart';
import 'package:jais/components/platform_widget.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/models/anime.dart';
import 'package:jais/models/platform.dart';
import 'package:notifications/notifications.dart' as notifications;

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

  List<PlatformWidget> _buildPlatforms() {
    final Map<int, Platform> platforms = <int, Platform>{};
    widget._anime.episodes
        .where(
          (element) => !platforms.containsKey(element.platform.id),
        )
        .forEach((e) => platforms[e.platform.id] = e.platform);

    final List<PlatformWidget> widgets = platforms.values
        .toSet()
        .map<PlatformWidget>((e) => PlatformWidget(e))
        .toList();
    return widgets;
  }

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
        Row(
          children: [
            BackButton(
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              flex: 6,
              child: Text(
                widget._anime.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            if (member_mapper.isConnected())
              IconButton(
                icon: Icon(
                  member_mapper.hasAnimeInWatchlist(widget._anime)
                      ? Icons.playlist_remove
                      : Icons.playlist_add,
                  color: member_mapper.hasAnimeInWatchlist(widget._anime)
                      ? Colors.red
                      : Colors.green,
                ),
                onPressed: () async {
                  final isWatchlistMode =
                      notifications.getType() == 'watchlist';

                  if (member_mapper.hasAnimeInWatchlist(widget._anime)) {
                    await member_mapper.removeAnimeInWatchlist(widget._anime);

                    if (isWatchlistMode) {
                      notifications.removeTopic(widget._anime.id.toString());
                    }
                  } else {
                    await member_mapper.addAnimeInWatchlist(widget._anime);

                    if (isWatchlistMode) {
                      notifications.addTopic(widget._anime.id.toString());
                    }
                  }

                  if (!mounted) return;
                  setState(() {});
                },
              ),
            IconButton(
              icon: const Icon(Icons.help),
              onPressed: () {
                show(
                  context,
                  widget: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _buildPlatforms(),
                          ),
                          if (widget._anime.genres.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 2.5,
                              ),
                            ),
                            Text(
                              widget._anime.genres.map((e) => e.fr).join(', '),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Divider(
                              height: 5,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget._anime.description ?? 'No description',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
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
