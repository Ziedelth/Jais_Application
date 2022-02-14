import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/components/loading_widget.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/long_anime.dart';
import 'package:jais/models/season.dart';
import 'package:jais/utils/anime_mapper.dart';
import 'package:jais/utils/logger.dart';
import 'package:jais/utils/utils.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({Key? key}) : super(key: key);

  @override
  _AnimesViewState createState() => _AnimesViewState();
}

class _AnimesViewState extends State<AnimesView> {
  bool _hasTap = false;
  LongAnime? _longAnime;
  Season? _selectedSeason;
  bool _notifications = false;

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
    if (_hasTap) {
      return Column(
        children: [
          Row(
            children: [
              BackButton(
                onPressed: () {
                  _hasTap = false;
                  setState(() {});
                },
              ),
              Expanded(
                flex: 4,
                child: Text(
                  _longAnime?.name ?? 'Anime',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  ),
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
          if (_longAnime?.seasons.isNotEmpty == true)
            DropdownButton<Season>(
              value: _selectedSeason,
              onChanged: (Season? newValue) {
                _selectedSeason = newValue;
                setState(() {});
              },
              items: _longAnime?.seasons
                      .map<DropdownMenuItem<Season>>(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text('Saison ${e.season}'),
                        ),
                      )
                      .toList() ??
                  [],
            ),
          if (_selectedSeason != null)
            Expanded(
              child: ListView.builder(
                controller: ScrollController(),
                itemCount: _selectedSeason!.episodes.length,
                itemBuilder: (context, index) {
                  return EpisodeWidget(
                    episode: _selectedSeason!.episodes[index],
                  );
                },
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(label: Text('Rechercher')),
          onChanged: (value) {
            AnimeMapper.onSearch(value);
            setState(() {});
          },
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Expanded(
          child: ListView.builder(
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
                  Logger.info(
                      message: "Click on anime: ${anime.name} (${anime.id})");

                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const Center(
                      child: Loading(),
                    ),
                  );

                  Utils.request(
                    'https://ziedelth.fr/php/v1/get_anime.php?id=${anime.id}',
                    200,
                    (p0) {
                      _longAnime = LongAnime.fromJson(jsonDecode(p0));
                      _selectedSeason = _longAnime?.seasons.isNotEmpty == true
                          ? _longAnime?.seasons.first
                          : null;
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
