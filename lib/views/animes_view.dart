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

  // Show loader dialog with a builder context
  Future<void> _showLoader(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertDialog(
        content: Loading(),
        actions: [],
      ),
    );
  }

  void _onTap(Anime anime) {
    _showLoader(context);

    get(
      'https://ziedelth.fr/api/v1/country/${Country.name}/anime/${anime.id}',
      (success) {
        try {
          Navigator.pop(context);
          _setDetails(
            animeDetails: AnimeDetails.fromJson(
              jsonDecode(success) as Map<String, dynamic>,
            ),
          );
        } catch (_) {}
      },
      (error) => null,
    );
  }

  void _updateFilter() {
    if (mounted) {
      setState(() {
        _widgets = filtered
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
  }

  @override
  void initState() {
    update(
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
