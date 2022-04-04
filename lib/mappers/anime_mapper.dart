import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/utils.dart';

const _limit = 9;

List<Widget> get _defaultList =>
    List.filled(_limit, const AnimeLoaderWidget(), growable: true);
List<Widget> list = _defaultList;
List<Widget> filtered = list;

// It's a way to reset the list of animes.
void clear() {
  list = _defaultList;
  filtered = list;
}

// It's a way to update the list of animes.
Future<void> update({Function()? onSuccess, Function()? onFailure}) async {
  if (list.whereType<AnimeWidget>().isNotEmpty) {
    filtered = list;
    onSuccess?.call();
    return;
  }

  await get(
    'https://ziedelth.fr/api/v1/country/${Country.name}/animes',
    (success) {
      try {
        list.removeWhere((element) => element is AnimeLoaderWidget);

        list.addAll(
          (jsonDecode(success) as List<dynamic>)
              .map(
                (e) => AnimeWidget(
                  anime: Anime.fromJson(e as Map<String, dynamic>),
                ),
              )
              .toList(),
        );

        filtered = list;
        onSuccess?.call();
      } catch (exception, stackTrace) {
        // Print exception and stack trace to the console
        debugPrint("Exception: $exception\nStackTrace: $stackTrace");

        onFailure?.call();
      }
    },
    (failure) {
      onFailure?.call();
    },
  );
}

// It's a way to filter the list of animes.
void onSearch(String value) {
  if (value.isEmpty) {
    filtered = list;
    return;
  }

  filtered = list
      .where(
        (element) =>
            element is AnimeWidget &&
            element.anime.name.toLowerCase().contains(value.toLowerCase()),
      )
      .toList();
}
