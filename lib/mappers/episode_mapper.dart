import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/utils.dart';

class EpisodeMapper {
  static const limit = 9;
  static int currentPage = 1;

  static List<Widget> get defaultList =>
      List.filled(limit, const EpisodeLoaderWidget(), growable: true);
  static List<Widget> list = defaultList;

  static void clear() {
    currentPage = 1;
    list = defaultList;
  }

  static void addLoader() {
    list.addAll(defaultList);
  }

  static Future<void> updateCurrentPage(
      {Function? onSuccess, Function? onFailure}) async {
    await Utils.request(
      'https://ziedelth.fr/api/v1/country/${Country.name}/page/$currentPage/limit/$limit/episodes',
      (success) {
        list.removeWhere((element) => element is EpisodeLoaderWidget);
        list.addAll((jsonDecode(success) as List<dynamic>)
            .map((e) => EpisodeWidget(episode: Episode.fromJson(e)))
            .toList());
        onSuccess?.call();
      },
      (failure) {
        onFailure?.call();
      },
    );
  }
}
