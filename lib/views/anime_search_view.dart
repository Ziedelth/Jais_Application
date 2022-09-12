import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_list.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/mappers/anime_search_notifier.dart';

class AnimeSearchView extends StatefulWidget {
  const AnimeSearchView({super.key});

  @override
  State<AnimeSearchView> createState() => _AnimeSearchViewState();
}

class _AnimeSearchViewState extends State<AnimeSearchView> {
  final _animeMapper = AnimeMapper();
  final _animeWidgets = <Widget>[];
  final _animeSearchNotifier = AnimeSearchNotifier();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _animeSearchNotifier.init();
      setState(() {});
    });
  }

  Future<void> _search(String query) async {
    final animes = await _animeMapper.search(query: query);
    if (animes == null) return;

    _animeWidgets
      ..clear()
      ..addAll(
        animes
            .map<Widget>(
              (e) => GestureDetector(
                child: e,
                onTap: () {
                  if (e is! AnimeWidget) return;
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/anime',
                    arguments: e.anime,
                  );
                },
              ),
            )
            .toList(),
      );

    setState(() {});
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
            await _animeSearchNotifier.addSearch(value);
            _search(value);
          },
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_animeSearchNotifier.hasSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Historique de recherche',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._animeSearchNotifier
                      .getSearch()
                      .map<Widget>(
                        (e) => ListTile(
                          title: Text(e),
                          trailing: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () async {
                              await _animeSearchNotifier.removeSearch(e);
                              setState(() {});
                            },
                          ),
                          onTap: () => _search(e),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
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
