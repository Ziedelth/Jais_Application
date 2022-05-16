import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/components/custom_gesture_detector.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/utils/jais_ad.dart';
import 'package:jais/utils/main_color.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/animes_view.dart';
import 'package:jais/views/episodes_view.dart';
import 'package:jais/views/scans_view.dart';
import 'package:jais/views/settings_view.dart';
import 'package:jais/views/watchlist_view.dart';
import 'package:notifications/notifications.dart' as notifications;
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) await MobileAds.instance.initialize();
  await notifications.init();
  await member_mapper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        useMaterial3: true,
        primaryColor: mainColors[900],
        colorScheme: ColorScheme.fromSeed(seedColor: mainColors[900]!),
      ),
      darkTheme: ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: mainColors[900],
        primarySwatch: MaterialColor(mainColors[900]!.value, mainColors),
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
  int _currentIndex = 0;
  late final PageController _pageController;

  void _changeTab(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!kIsWeb) createBanner();
      await member_mapper.loginWithToken();
      if (!mounted) return;
      setState(() {});

      if (member_mapper.isConnected()) {
        showSnackBar(
          context,
          'De retour, ${member_mapper.getMember()?.pseudo} !',
        );
      }
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
                    CustomGestureDetector(
                      duration: const Duration(seconds: 5),
                      onLongPress: () async {
                        final packageInfo = await PackageInfo.fromPlatform();

                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('À propos'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Version ${packageInfo.version}'),
                                Text('© 2021-${DateTime.now().year} Jaïs'),
                                const Text('Powered by Ziedelth.fr'),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RoundBorderWidget(
                            widget: Image.asset('assets/icon.jpg'),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Jaïs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Pacifico',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: bannerAd != null
                          ? AdWidget(ad: bannerAd!)
                          : Container(color: Colors.black),
                    ),
                    const SizedBox(width: 10),
                    if (_currentIndex == 2)
                      IconButton(
                        alignment: Alignment.centerRight,
                        icon: const Icon(Icons.search),
                        onPressed: () => _animesKey.currentState?.showSearch(),
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
                  const EpisodesView(),
                  const ScansView(),
                  AnimesView(key: _animesKey),
                  if (member_mapper.isConnected()) const WatchlistView(),
                  SettingsView(
                    onLogin: () {
                      _changeTab(4);
                      _pageController.jumpToPage(5);
                    },
                    onLogout: () => _changeTab(3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        ),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Episodes',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Scans',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Animes',
          ),
          if (member_mapper.isConnected())
            const BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check),
              label: 'Watchlist',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}
