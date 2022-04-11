import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/components/loading_widget.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/anime_details/anime_details_view.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({Key? key}) : super(key: key);

  @override
  _AnimesViewState createState() => _AnimesViewState();
}

class _AnimesViewState extends State<AnimesView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _key = GlobalKey();
  bool _isLoading = true;

  bool _hasTap = false;
  Anime? _anime;

  Future<void> _on(Anime anime, int count) async {
    // if (!isConnected()) {
    //   return;
    // }
    //
    // await put(
    //   'https://ziedelth.fr/api/v1/member/notation/anime',
    //   {
    //     'token': token,
    //     'id': '${anime.id}',
    //     'count': '$count',
    //   },
    //   (success) async {
    //     await get(
    //       'https://ziedelth.fr/api/v1/statistics/member/${user?.pseudo}',
    //       (success) {
    //         user?.statistics = Statistics.fromJson(
    //           jsonDecode(success) as Map<String, dynamic>,
    //         );
    //
    //         if (mounted) {
    //           setState(() {
    //             clear();
    //
    //             update(
    //               onSuccess: _updateFilter,
    //               onUp: (Anime anime) => _on(anime, 1),
    //               onDown: (Anime anime) => _on(anime, -1),
    //             );
    //
    //             _key = GlobalKey();
    //           });
    //         }
    //       },
    //       (_) => null,
    //     );
    //   },
    //   (_) => null,
    // );
  }

  void _setDetails({Anime? anime}) {
    setState(() {
      _anime = anime;
      _hasTap = anime != null;
    });
  }

  // Show loader dialog with a builder context
  Future<void> _showLoader(BuildContext context) async => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const AlertDialog(
          content: Loading(),
          actions: [],
        ),
      );

  Future<void> _onTap(Anime anime) async {
    _showLoader(context);
    anime.episodes.clear();
    anime.scans.clear();

    await get(
      'https://api.ziedelth.fr/episodes/anime/${anime.id}',
      (success) {
        try {
          anime.episodes.addAll(
            (jsonDecode(success) as List)
                .map<Episode>(
                  (e) => Episode.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          );
        } catch (exception, stackTrace) {
          debugPrint('Error on episodes : $exception\n$stackTrace');
        }
      },
      (error) => null,
    );

    await get(
      'https://api.ziedelth.fr/scans/anime/${anime.id}',
      (success) {
        try {
          anime.scans.addAll(
            (jsonDecode(success) as List)
                .map<Scan>((e) => Scan.fromJson(e as Map<String, dynamic>))
                .toList(),
          );
        } catch (exception, stackTrace) {
          debugPrint('Error on scans : $exception\n$stackTrace');
        }
      },
      (error) => null,
    );

    if (!mounted) return;
    Navigator.pop(context);

    _setDetails(
      anime: anime,
    );
  }

  Future<void> rebuildAnimes() async {
    await updateCurrentPage(
      onSuccess: () {
        if (!mounted) {
          return;
        }

        setState(() => _isLoading = false);
      },
      onUp: (Anime anime) => _on(anime, 1),
      onDown: (Anime anime) => _on(anime, -1),
    );
  }

  @override
  void initState() {
    clear();
    rebuildAnimes();

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        currentPage++;
        addLoader();

        if (mounted) {
          setState(() {});
        }

        await rebuildAnimes();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasTap && _anime != null) {
      return AnimeDetailsView(_anime!, _setDetails);
    }

    return JList(
      key: _key,
      controller: _scrollController,
      children: list
          .map<Widget>(
            (e) => GestureDetector(
              child: e,
              onTap: () => e is AnimeWidget ? _onTap(e.anime) : null,
            ),
          )
          .toList(),
    );
  }
}
