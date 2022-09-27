import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/mappers/country_mapper.dart';
import 'package:jais/mappers/episode_type_mapper.dart';
import 'package:jais/mappers/genre_mapper.dart';
import 'package:jais/mappers/lang_type_mapper.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/mappers/platform_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/anime_details_view.dart';
import 'package:jais/views/anime_search_view.dart';
import 'package:jais/views/home_view.dart';
import 'package:logger/logger.dart';
import 'package:notifications/notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    Logger.error(
      'An error occurred with Flutter',
      details.exception,
      details.stack,
    );
  };

  Logger.info('Initializing...');

  try {
    Logger.info('Initializing Google Mobile Ads...');
    await MobileAds.instance.initialize();
    createGlobalBanner();
  } catch (exception, stacktrace) {
    Logger.error(
      'An error occurred while initializing Google Mobile Ads',
      exception,
      stacktrace,
    );
  }

  try {
    Logger.info('Initializing Notifications...');
    Notifications.instance.init();
  } catch (exception, stacktrace) {
    Logger.error(
      'An error occurred while initializing Notifications',
      exception,
      stacktrace,
    );
  }

  Logger.info('Initializing mappers...');

  await Future.wait([
    MemberMapper.instance.init(),
    CountryMapper.instance.update(),
    EpisodeTypeMapper.instance.update(),
    GenreMapper.instance.update(),
    LangTypeMapper.instance.update(),
    PlatformMapper.instance.update(),
  ]);

  Logger.info('Running app...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final _mainColor = mainColors[900]!;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jaïs",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        useMaterial3: true,
        primaryColor: _mainColor,
        colorScheme: ColorScheme.fromSeed(seedColor: _mainColor),
      ),
      darkTheme: ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: _mainColor,
        primarySwatch: MaterialColor(_mainColor.value, mainColors),
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
              return SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(0.0, 1.0), end: Offset.zero).chain(
                    CurveTween(curve: Curves.ease),
                  ),
                ),
                child: child,
              );
            },
          );
        }

        return MaterialPageRoute(
          builder: (context) {
            return SafeArea(
              child: routes[settings.name]?.call(context) ?? const MyHomePage(),
            );
          },
        );
      },
      initialRoute: '/',
    );
  }
}
