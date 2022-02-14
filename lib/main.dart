import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jais/components/loading_widget.dart';
import 'package:jais/utils/logger.dart';
import 'package:jais/utils/main_color.dart';
import 'package:jais/views/animes_view.dart';
import 'package:jais/views/episodes_view.dart';
import 'package:jais/views/scans_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await GetStorage.init();
  Logger.init();

  FirebaseMessaging.instance.subscribeToTopic("animes");
  // FirebaseMessaging.instance.unsubscribeFromTopic("animes");

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await GetStorage.init();
  Logger.init();
  Logger.debug(message: 'A bg message just showed up :  ${message.messageId}');
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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Center(
            child: <Widget>[
              const EpisodesView(),
              const ScansView(),
              const AnimesView(),
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
            icon: Icon(Icons.book),
            label: 'Scans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplay),
            label: 'Animes',
          ),
        ],
      ),
    );
  }
}
