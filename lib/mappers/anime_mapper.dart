import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/utils.dart';

const _limit = 9;
int currentPage = 1;

List<Widget> get _defaultList =>
    List.filled(_limit, const AnimeLoaderWidget(), growable: true);
List<Widget> list = _defaultList;

void clear() {
  currentPage = 1;
  list = _defaultList;
}

void addLoader() => list.addAll(_defaultList);

void removeLoader() =>
    list.removeWhere((element) => element is AnimeLoaderWidget);

Future<void> updateCurrentPage({
  Function()? onSuccess,
  Function()? onFailure,
  Function(Anime anime)? onUp,
  Function(Anime anime)? onDown,
}) async =>
    get(
      'https://api.ziedelth.fr/animes/country/${Country.name}/page/$currentPage/limit/$_limit',
      (success) {
        try {
          removeLoader();
          list.addAll(
            (jsonDecode(success) as List<dynamic>)
                .map(
                  (e) => AnimeWidget(
                    anime: Anime.fromJson(e as Map<String, dynamic>),
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
