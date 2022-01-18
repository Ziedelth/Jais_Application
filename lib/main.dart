import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jais/components/episode_widget.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/logger.dart';
import 'package:jais/utils/main_color.dart';

import 'components/episode_loader_widget.dart';
import 'components/loading_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Logger.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(MainColor.mainColor),
        primarySwatch: MaterialColor(MainColor.mainColor, MainColor.mainColors),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0, episodesLimit = 9;
  late Future<List<Episode>?> _request;
  final ScrollController _scrollController = ScrollController();

  Future<List<Episode>?> makeRequest() async {
    Logger.info(message: 'Fetching latest episodes...');

    try {
      Logger.debug(message: 'Making request...');
      final http.Response response = await http.get(
        Uri.parse(
          'https://ziedelth.fr/php/v1/episodes.php?limit=$episodesLimit',
        ),
      );

      if (response.statusCode == 201) {
        Logger.debug(message: 'Good response! Body: ${response.body}');

        return (jsonDecode(response.body) as List<dynamic>)
            .map((e) => Episode.fromJson(e))
            .toList();
      } else {
        Logger.warn(message: 'Bad response! Body: ${response.body}');
        return null;
      }
    } catch (exception, stacktrace) {
      Logger.error(message: 'Error : $exception - ${stacktrace.toString()}');
      return null;
    }
  }

  void update() {
    setState(() {
      _request = makeRequest();
    });
  }

  @override
  void initState() {
    super.initState();
    _request = makeRequest();

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0) {
        episodesLimit += 9;
        update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Center(
            child: <Widget>[
              FutureBuilder<List<Episode>?>(
                future: _request,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      final List<Episode> episodes = snapshot.data!;

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: episodes.length,
                        itemBuilder: (context, index) {
                          return EpisodeWidget(episode: episodes[index]);
                        },
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const EpisodeLoaderWidget();
                      },
                    );
                  }
                },
              ),
              const Loading(),
            ].elementAt(_currentIndex),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Épisodes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplay),
            label: 'Animés',
          ),
        ],
      ),
    );
  }
}
