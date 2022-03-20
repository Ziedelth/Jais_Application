import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/components/jsearch.dart';
import 'package:jais/components/loading_widget.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/anime_details.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/anime_details/anime_details_view.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({Key? key}) : super(key: key);

  @override
  _AnimesViewState createState() => _AnimesViewState();
}

class _AnimesViewState extends State<AnimesView> {
  bool _hasTap = false;
  AnimeDetails? _animeDetails;
  List<Widget> _widgets = [];

  void _setDetails({AnimeDetails? animeDetails}) {
    setState(() {
      _animeDetails = animeDetails;
      _hasTap = animeDetails != null;
    });
  }

  void _onTap(Anime anime) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: const Loading(),
        actions: [],
      ),
    );

    Utils.get(
      'https://ziedelth.fr/api/v1/country/${Country.name}/anime/${anime.id}',
      (success) {
        try {
          Navigator.pop(context);
          _setDetails(animeDetails: AnimeDetails.fromJson(jsonDecode(success)));
        } catch (exception, stackTrace) {
          debugPrint('$exception');
          debugPrint('$stackTrace');
        }
      },
      (error) => null,
    );
  }

  void _updateFilter() {
    setState(() {
      _widgets = AnimeMapper.filtered
          .map<Widget>(
            (element) => element is! AnimeWidget
                ? element
                : GestureDetector(
                    child: element,
                    onTap: () => _onTap(element.anime),
                  ),
          )
          .toList();
    });
  }

  @override
  void initState() {
    AnimeMapper.update(
      onSuccess: _updateFilter,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasTap && _animeDetails != null) {
      return AnimeDetailsView(_animeDetails!, _setDetails);
    }

    return Column(
      children: [
        JSearch(callback: _updateFilter),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Expanded(
          child: JList(
            children: _widgets,
          ),
        )
      ],
    );
  }
}
