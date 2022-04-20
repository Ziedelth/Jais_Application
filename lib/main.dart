import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/utils/jais_ad.dart';
import 'package:jais/utils/main_color.dart';
import 'package:jais/utils/notifications.dart';
import 'package:jais/views/animes_view.dart';
import 'package:jais/views/episodes_view.dart';
import 'package:jais/views/scans_view.dart';
import 'package:jais/views/watchlist_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await MobileAds.instance.initialize();
  await init();
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
        primaryColor: mainColors[900],
        primarySwatch: MaterialColor(mainColors[900]!.value, mainColors),
        backgroundColor: Colors.black,
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
  final _animesKey = GlobalKey<AnimesViewState>();
  int _currentIndex = 1;
  late final PageController _pageController;

  void _changeTab(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentIndex);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      createVideo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: RoundBorderWidget(
                        widget: Image.asset('assets/icon.jpg'),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7.5),
                        child: Text(
                          'Jaïs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                      ),
                    ),
                    if (_currentIndex == 3)
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () =>
                              _animesKey.currentState?.showSearch(),
                        ),
                      ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          Icons.card_giftcard,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: showVideo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _changeTab,
                children: <Widget>[
                  const WatchlistView(),
                  const EpisodesView(),
                  const ScansView(),
                  AnimesView(
                    key: _animesKey,
                  ),
                  // const SettingsView(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // backgroundColor: Colors.black,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: (index) => _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Episodes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Scans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Animes',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Paramètres',
          // ),
        ],
      ),
    );
  }
}
