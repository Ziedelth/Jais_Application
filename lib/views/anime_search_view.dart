import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_list.dart';
import 'package:jais/components/loading_widget.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/utils/utils.dart';

class AnimeSearchView extends StatefulWidget {
  const AnimeSearchView({super.key});

  @override
  _AnimeSearchViewState createState() => _AnimeSearchViewState();
}

class _AnimeSearchViewState extends State<AnimeSearchView> {
  final _animeMapper = AnimeMapper();
  final _animeWidgets = <Widget>[];

  Future<void> _onTap(Anime anime) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertDialog(
        content: Loading(),
      ),
    );

    final details = await _animeMapper.loadDetails(anime);
    if (!mounted) return;
    Navigator.pop(context);

    // If details is null, show error
    if (details == null) {
      showSnackBar(context, 'An error occurred while loading details');
      return;
    }

    Navigator.pushNamed(context, '/anime', arguments: details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Rechercher',
            border: InputBorder.none,
          ),
          autofocus: true,
          onSubmitted: (value) async {
            final animes = await _animeMapper.search(query: value);
            if (animes == null) return;

            _animeWidgets
              ..clear()
              ..addAll(
                animes
                    .map<Widget>(
                      (e) => GestureDetector(
                        child: e,
                        onTap: () {
                          Navigator.pop(context);
                          _onTap(e.anime);
                        },
                      ),
                    )
                    .toList(),
              );

            setState(() {});
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimeList(
              children: _animeWidgets,
            ),
          ),
        ],
      ),
    );
  }
}
