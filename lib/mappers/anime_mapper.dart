import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/utils/utils.dart';

class AnimeMapper {
  static List<Widget> list =
      List.filled(9, const AnimeLoaderWidget(), growable: true);
  static List<Widget> filtered = list;

  static void clear() {
    list = List.filled(9, const AnimeLoaderWidget(), growable: true);
    filtered = list;
  }

  static Future<void> update({Function? onSuccess, Function? onFailure}) async {
    await Utils.request(
      'https://ziedelth.fr/api/v1/country/fr/animes',
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
