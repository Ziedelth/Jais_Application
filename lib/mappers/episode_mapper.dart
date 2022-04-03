import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/utils.dart';

const limit = 9;
int currentPage = 1;

List<Widget> get defaultList =>
    List.filled(limit, const EpisodeLoaderWidget(), growable: true);
List<Widget> list = defaultList;

void clear() {
  currentPage = 1;
  list = defaultList;
}

void addLoader() => list.addAll(defaultList);
void removeLoader() =>
    list.removeWhere((element) => element is EpisodeLoaderWidget);

Future<void> updateCurrentPage({
  Function()? onSuccess,
  Function()? onFailure,
}) async =>
    get(
      'https://ziedelth.fr/api/v1/country/${Country.name}/page/$currentPage/limit/$limit/episodes',
      (success) {
        try {
          removeLoader();
          list.addAll(
            (jsonDecode(success) as List<dynamic>)
                .map(
                  (e) => EpisodeWidget(
                    episode: Episode.fromJson(e as Map<String, dynamic>),
                  ),
                )
                .toList(),
          );
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
