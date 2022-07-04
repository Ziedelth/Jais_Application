import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/mappers/country_mapper.dart';
import 'package:jais/mappers/lang_type_mapper.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/models/anime.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/anime_details_view.dart';
import 'package:jais/views/anime_search_view.dart';
import 'package:jais/views/home_view.dart';
import 'package:notifications/notifications.dart' as notifications;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  try {
    await notifications.init();
  } catch (_) {}

  await member_mapper.init();
  await CountryMapper().update();
  LangTypeMapper.instance.update();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      onGenerateRoute: (RouteSettings settings) {
        final arguments = settings.arguments;

        final routes = {
          '/': (context) => const MyHomePage(),
          '/search': (context) => const AnimeSearchView(),
          '/anime': (context) => AnimeDetailsView(arguments! as Anime),
        };

        if (settings.name != '/') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: routes[settings.name]?.call(context) ??
                      const MyHomePage(),
                ),
              );
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              return SlideTransition(
                position: animation.drive(
                  Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  ),
                ),
                child: child,
              );
            },
          );
        }

        return MaterialPageRoute(
          builder: routes[settings.name] ?? (context) => const MyHomePage(),
        );
      },
      initialRoute: '/',
    );
  }
}
