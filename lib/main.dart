import 'dart:async';
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
  final int limit = 9;
  int _currentIndex = 0, _currentPage = 1;
  final ValueNotifier<List<Widget>> _request = ValueNotifier<List<Widget>>(List.filled(9, const EpisodeLoaderWidget(), growable: true));
  final ScrollController _scrollController = ScrollController();

  Future<void> makeRequest() async {
    Logger.info(message: 'Fetching latest episodes...');

    try {
      final String url = 'https://ziedelth.fr/php/v1/episodes.php?limit=$limit&page=$_currentPage';
      Logger.debug(message: 'Making request $url...');

      final http.Response response = await http.get(
        Uri.parse(
          url,
        ),
      );

      if (response.statusCode == 201) {
        Logger.debug(message: 'Good response!');
        _request.value.removeWhere((element) => element is EpisodeLoaderWidget);
        _request.value.addAll((jsonDecode(response.body) as List<dynamic>).map((e) => EpisodeWidget(episode: Episode.fromJson(e))).toList());

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
    super.initState();
    makeRequest();

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0) {
        _currentPage++;
        setState(() => _request.value.addAll(List.filled(limit, const EpisodeLoaderWidget(), growable: true)));
        await makeRequest();
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
              ValueListenableBuilder(
                valueListenable: _request,
                builder: (context, List<Widget> value, child) {
                  return RefreshIndicator(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return value[index];
                      },
                    ),
                    onRefresh: () async => await makeRequest(),
                  );
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
        onTap: (index) {
          setState(() => _currentIndex = index);
          _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 1000));
        },
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
