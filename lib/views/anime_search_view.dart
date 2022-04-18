import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/models/anime.dart';

class AnimeSearchView extends StatefulWidget {
  const AnimeSearchView({
    required this.animeMapper,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final AnimeMapper animeMapper;
  final Function(Anime) onTap;

  @override
  _AnimeSearchViewState createState() => _AnimeSearchViewState();
}

class _AnimeSearchViewState extends State<AnimeSearchView> {
  final List<Widget> _animeWidgets = [];

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
          onChanged: (value) async {
            final animes = await widget.animeMapper.search(query: value);
            if (animes == null) return;

            _animeWidgets.clear();
            _animeWidgets.addAll(
              animes
                  .map<Widget>(
                    (e) => GestureDetector(
                      child: e,
                      onTap: () {
                        Navigator.pop(context);
                        widget.onTap(e.anime);
                      },
                    ),
                  )
                  .toList(),
            );

            if (!mounted) return;
            setState(() {});
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: JList(
              children: _animeWidgets,
            ),
          ),
        ],
      ),
    );
  }
}
