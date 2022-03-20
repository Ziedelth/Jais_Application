import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/utils/jais_ad.dart';
import 'package:jais/utils/main_color.dart';
import 'package:jais/utils/notifications.dart';
import 'package:jais/views/animes_view.dart';
import 'package:jais/views/episodes_view.dart';
import 'package:jais/views/scans_view.dart';
import 'package:jais/views/settings_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await MobileAds.instance.initialize();
  await JaisNotifications.init();
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
  final List<Widget> _widgets = const <Widget>[
    EpisodesView(),
    ScansView(),
    AnimesView(),
    SettingsView(),
  ];

  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  void _changeTab(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    JaisAd.createVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: PageView(
            controller: _pageController,
            onPageChanged: _changeTab,
            children: _widgets,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.black,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: (index) => _pageController.animateToPage(index,
            duration: Duration(milliseconds: 500), curve: Curves.ease),
        items: const [
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}
