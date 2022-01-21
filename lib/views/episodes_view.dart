import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jais/components/episode_loader_widget.dart';
import 'package:jais/components/episode_widget.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/logger.dart';

class EpisodesView extends StatefulWidget {
  const EpisodesView({Key? key}) : super(key: key);

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  final int limit = 9;
  int _currentPage = 1;
  final ValueNotifier<List<Widget>> _request = ValueNotifier<List<Widget>>(
      List.filled(9, const EpisodeLoaderWidget(), growable: true));
  final ScrollController _scrollController = ScrollController();

  Future<void> makeRequest() async {
    Logger.info(message: 'Fetching latest episodes...');

    try {
      final String url =
          'https://ziedelth.fr/php/v1/episodes.php?limit=$limit&page=$_currentPage';
      Logger.debug(message: 'Making request $url...');

      final http.Response response = await http.get(
        Uri.parse(
          url,
        ),
      );

      if (response.statusCode == 201) {
        Logger.debug(message: 'Good response!');
        _request.value.removeWhere((element) => element is EpisodeLoaderWidget);
        _request.value.addAll((jsonDecode(response.body) as List<dynamic>)
            .map((e) => EpisodeWidget(episode: Episode.fromJson(e)))
            .toList());

        setState(() => {});
      } else {
        Logger.warn(message: 'Bad response! Body: ${response.body}');
      }
    } catch (exception, stacktrace) {
      Logger.error(message: 'Error : $exception - ${stacktrace.toString()}');
    }
  }

  @override
  void initState() {
    makeRequest();

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0) {
        _currentPage++;
        setState(() => _request.value.addAll(
            List.filled(limit, const EpisodeLoaderWidget(), growable: true)));
        await makeRequest();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _request,
      builder: (context, List<Widget> value, child) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: value.length,
          itemBuilder: (context, index) {
            return value[index];
          },
        );
      },
    );
  }
}
