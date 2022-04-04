import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/utils.dart';

const _limit = 9;
int currentPage = 1;

List<Widget> get _defaultList =>
    List.filled(_limit, const EpisodeLoaderWidget(), growable: true);
List<Widget> list = _defaultList;

void clear() {
  currentPage = 1;
  list = _defaultList;
}

void addLoader() => list.addAll(_defaultList);

void removeLoader() =>
    list.removeWhere((element) => element is EpisodeLoaderWidget);

Future<void> updateCurrentPage({
  Function()? onSuccess,
  Function()? onFailure,
  Function(Episode episode)? onUp,
  Function(Episode episode)? onDown,
}) async =>
    get(
      'https://ziedelth.fr/api/v1/country/${Country.name}/page/$currentPage/limit/$_limit/episodes',
      (success) {
        try {
          removeLoader();
          list.addAll(
            (jsonDecode(success) as List<dynamic>)
                .map(
                  (e) => EpisodeWidget(
                    episode: Episode.fromJson(e as Map<String, dynamic>),
                    onUp: onUp,
                    onDown: onDown,
                  ),
                )
                .toList(),
          );
          onSuccess?.call();
        } catch (_) {
          onFailure?.call();
        }
      },
      (failure) {
        onFailure?.call();
      },
    );
