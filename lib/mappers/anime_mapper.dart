import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/utils.dart';

class AnimeMapper {
  static const limit = 9;

  static List<Widget> get defaultList =>
      List.filled(limit, const AnimeLoaderWidget(), growable: true);
  static List<Widget> list = defaultList;
  static List<Widget> filtered = list;

  // Clear the current list with the default list
  static void clear() {
    list = defaultList;
    filtered = list;
  }

  // Remove all anime loader widgets from the list.
  static void removeLoaders() {
    list.removeWhere((element) => element is AnimeLoaderWidget);
    filtered.removeWhere((element) => element is AnimeLoaderWidget);
  }

  // It's a way to update the list of animes.
  static Future<void> update({Function? onSuccess, Function? onFailure}) async {
    if (list.where((element) => element is AnimeWidget).isNotEmpty) {
      filtered = list;
      onSuccess?.call();
      return;
    }

    await Utils.get(
      'https://ziedelth.fr/api/v1/country/${Country.name}/animes',
      (success) {
        removeLoaders();
        filtered = list
          ..addAll((jsonDecode(success) as List<dynamic>)
              .map((e) => AnimeWidget(anime: Anime.fromJson(e)))
              .toList());
        onSuccess?.call();
      },
      (failure) {
        onFailure?.call();
      },
    );
  }

  static void filter(String query) {
    if (query.isEmpty) {
      filtered = list;
      return;
    }

    filtered = list.where((element) => element is AnimeWidget).toList()
      ..retainWhere((element) => (element as AnimeWidget)
          .anime
          .name
          .toLowerCase()
          .contains(query.toLowerCase()));
  }
}
