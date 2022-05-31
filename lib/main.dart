import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/utils/main_color.dart';
import 'package:jais/views/home_view.dart';
import 'package:notifications/notifications.dart' as notifications;

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
    final mainColor = mainColors[900]!;

    return MaterialApp(
      title: "Jaïs",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        useMaterial3: true,
        primaryColor: mainColor,
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
      ),
      darkTheme: ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: mainColor,
        primarySwatch: MaterialColor(mainColor.value, mainColors),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MyHomePage(),
    );
  }
}
