import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/utils.dart';

class EpisodeMapper {
  static const limit = 9;
  static int currentPage = 1;
  static List<Widget> list =
      List.filled(limit, const EpisodeLoaderWidget(), growable: true);

  static void clear() {
    currentPage = 1;
    list = List.filled(limit, const EpisodeLoaderWidget(), growable: true);
  }

  static void addLoader() {
    list.addAll(
        List.filled(limit, const EpisodeLoaderWidget(), growable: true));
  }

  static Future<void> updateCurrentPage(
      {Function? onSuccess, Function? onFailure}) async {
    await Utils.request(
      'https://ziedelth.fr/php/v1/episodes.php?limit=$limit&page=$currentPage',
      200,
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
