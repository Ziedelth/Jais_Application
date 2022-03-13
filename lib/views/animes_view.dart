import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/components/loading_widget.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/anime_details.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/main_color.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/anime_details_view.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({Key? key}) : super(key: key);

  @override
  _AnimesViewState createState() => _AnimesViewState();
}

class _AnimesViewState extends State<AnimesView> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _hasTap = false;
  AnimeDetails? _animeDetails;

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
    if (_hasTap && _animeDetails != null) {
      return AnimeDetailsView(_animeDetails!, () {
        setState(() {
          _hasTap = false;
          _animeDetails = null;
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
                    'https://ziedelth.fr/api/v1/country/${Country.name}/anime/${anime.id}',
                    (p0) {
                      _animeDetails = AnimeDetails.fromJson(jsonDecode(p0));
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
