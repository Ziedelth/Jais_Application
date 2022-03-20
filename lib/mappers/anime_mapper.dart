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

  // It's a way to reset the list of animes.
  static void clear() {
    list = defaultList;
    filtered = list;
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
        list.removeWhere((element) => element is AnimeLoaderWidget);
        list.addAll((jsonDecode(success) as List<dynamic>)
            .map((e) => AnimeWidget(anime: Anime.fromJson(e)))
            .toList());
        filtered = list;
        onSuccess?.call();
      },
      (failure) {
        onFailure?.call();
      },
    );
  }

  // It's a way to filter the list of animes.
  static void onSearch(String value) {
    if (value.isEmpty) {
      filtered = list;
      return;
    }

    filtered = list
        .where((element) =>
            element is AnimeWidget &&
            element.anime.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }
}
