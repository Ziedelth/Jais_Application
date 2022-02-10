import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/components/scans/scan_loader_widget.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/scan.dart';

import 'logger.dart';

class Utils {
  static const limitEpisodes = 9;
  static const limitScans = 18;
  static int episodeCurrentPage = 1;
  static List<Widget> episodes = List.filled(limitEpisodes, const EpisodeLoaderWidget(), growable: true);
  static int scanCurrentPage = 1;
  static List<Widget> scans = List.filled(limitScans, const ScanLoaderWidget(), growable: true);

  static String printTimeSince(DateTime dateTime) {
    final double seconds = (DateTime.now().millisecondsSinceEpoch.floor() -
        dateTime.millisecondsSinceEpoch.floor()) /
        1000;
    double interval = seconds / 31536000;
    if (interval > 1) {
      return '${interval.floor()} an${interval >= 2 ? 's' : ''}';
    }
    interval = seconds / 2592000;
    if (interval > 1) {
      return '${interval.floor()} mois';
    }
    interval = seconds / 86400;
    if (interval > 1) {
      return '${interval.floor()} jour${interval >= 2 ? 's' : ''}';
    }
    interval = seconds / 3600;
    if (interval > 1) {
      return '${interval.floor()} heure${interval >= 2 ? 's' : ''}';
    }
    interval = seconds / 60;
    if (interval > 1) {
      return '${interval.floor()} minute${interval >= 2 ? 's' : ''}';
    }
    return 'A l\'instant';
  }

  static Future<void> request(String url, int successCode,
      Function(String) onSuccess, Function(String) onFailure) async {
    try {
      Logger.debug(message: 'Making request $url...');

      final http.Response response = await http.get(
        Uri.parse(
          url,
        ),
      );

      if (response.statusCode != successCode) {
        Logger.warn(message: 'Bad response! Body: ${response.body}');
        onFailure(response.body);
        return;
      }

      Logger.debug(message: 'Good response!');
      onSuccess(response.body);
    } catch (exception, stacktrace) {
      Logger.error(message: 'Error : $exception - ${stacktrace.toString()}');
      onFailure(stacktrace.toString());
    }
  }

  static void clearEpisodes() {
    episodeCurrentPage = 1;
    episodes = List.filled(limitEpisodes, const EpisodeLoaderWidget(), growable: true);
  }

  static void addLoaderEpisodes() {
    episodes.addAll(
        List.filled(limitEpisodes, const EpisodeLoaderWidget(), growable: true));
  }

  static Future<void> updateCurrentPageEpisodes(
      {Function? onSuccess, Function? onFailure}) async {
    await request(
      'https://ziedelth.fr/php/v1/episodes.php?limit=$limitEpisodes&page=$episodeCurrentPage',
      201,
          (success) {
        episodes.removeWhere((element) => element is EpisodeLoaderWidget);
        episodes.addAll((jsonDecode(success) as List<dynamic>)
            .map((e) => EpisodeWidget(episode: Episode.fromJson(e)))
            .toList());
        onSuccess?.call();
      },
          (failure) {
        onFailure?.call();
      },
    );
  }

  static void clearScans() {
    scanCurrentPage = 1;
    scans = List.filled(limitScans, const ScanLoaderWidget(), growable: true);
  }

  static void addLoaderScans() {
    episodes.addAll(
        List.filled(limitScans, const ScanLoaderWidget(), growable: true));
  }

  static Future<void> updateCurrentPageScans(
      {Function? onSuccess, Function? onFailure}) async {
    await request(
      'https://ziedelth.fr/php/v1/scans.php?limit=$limitScans&page=$scanCurrentPage',
      201,
          (success) {
        scans.removeWhere((element) => element is ScanLoaderWidget);
        scans.addAll((jsonDecode(success) as List<dynamic>)
            .map((e) => ScanWidget(scan: Scan.fromJson(e)))
            .toList());
        onSuccess?.call();
      },
          (failure) {
        onFailure?.call();
      },
    );
  }
}
