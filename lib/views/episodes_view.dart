import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:jais/mappers/user_mapper.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/statistics.dart';
import 'package:jais/utils/utils.dart';

class EpisodesView extends StatefulWidget {
  const EpisodesView({Key? key}) : super(key: key);

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  final ScrollController _scrollController = ScrollController();
  GlobalKey _key = GlobalKey();
  bool _isLoading = true;

  Future<void> _on(Episode episode, int count) async {
    if (!isConnected()) {
      return;
    }

    await put(
      'https://ziedelth.fr/api/v1/member/notation/episode',
      {
        'token': token,
        'id': '${episode.id}',
        'count': '$count',
      },
      (success) async {
        await get(
          'https://ziedelth.fr/api/v1/statistics/member/${user?.pseudo}',
          (success) {
            user?.statistics = Statistics.fromJson(
              jsonDecode(success) as Map<String, dynamic>,
            );

            if (mounted) {
              setState(() {
                clear();
                rebuildEpisodes();
                _key = GlobalKey();
              });
            }
          },
          (_) => null,
        );
      },
      (_) => null,
    );
  }

  Future<void> rebuildEpisodes() async {
    await updateCurrentPage(
      onSuccess: () {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      },
      onUp: (Episode episode) => _on(episode, 1),
      onDown: (Episode episode) => _on(episode, -1),
    );
  }

  @override
  void initState() {
    super.initState();

    clear();
    rebuildEpisodes();

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        currentPage++;
        addLoader();

        if (mounted) {
          setState(() {});
        }

        await rebuildEpisodes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return JList(
      key: _key,
      controller: _scrollController,
      children: list,
    );
  }
}
