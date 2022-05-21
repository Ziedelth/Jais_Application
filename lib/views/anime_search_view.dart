import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/components/animes/anime_list.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/utils/jais_ad.dart';

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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!kIsWeb) createSearchBanner();
    });
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
            final animes = await widget.animeMapper.search(query: value);
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
                      widget.onTap(e.anime);
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
          if (!kIsWeb && searchBannerAd != null)
            SizedBox(
              height: 50,
              child: AdWidget(ad: searchBannerAd!),
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
