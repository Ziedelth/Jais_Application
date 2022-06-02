import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/components/custom_gesture_detector.dart';
import 'package:jais/components/navbar.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/mappers/display_mapper.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/mappers/navbar_mapper.dart';
import 'package:jais/utils/jais_ad.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/animes_view.dart';
import 'package:jais/views/episodes_view.dart';
import 'package:jais/views/scans_view.dart';
import 'package:jais/views/settings_view.dart';
import 'package:jais/views/watchlist_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  final int defaultPage;

  const MyHomePage({this.defaultPage = 0, super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DisplayMapper _displayMapper = DisplayMapper();
  late final NavbarMapper _navbarMapper;
  final _animesKey = GlobalKey<AnimesViewState>();

  @override
  void initState() {
    super.initState();
    _navbarMapper = NavbarMapper(defaultPage: widget.defaultPage);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Navbar(
              navbarMapper: _navbarMapper,
              onPageChanged: (page) =>
                  setState(() => _navbarMapper.currentPage = page),
            ),
            Expanded(
              child: PageView(
                controller: _navbarMapper.pageController,
                onPageChanged: (i) => setState(() => _navbarMapper.currentPage = i),
                children: <Widget>[
                  const EpisodesView(),
                  const ScansView(),
                  AnimesView(key: _animesKey),
                  if (member_mapper.isConnected()) WatchlistView(),
                  const SettingsView(
                      // onLogin: () {
                      //   _changeTab(4);
                      //   _navbarMapper.pageController.jumpToPage(5);
                      // },
                      // onLogout: () => _changeTab(3),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _displayMapper.isOnMobileOnWebOrUseApp(context)
          ? BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              currentIndex: _navbarMapper.currentPage,
              onTap: (index) => _navbarMapper.currentPage = index,
              items: _navbarMapper.itemsBottomNavBar,
            )
          : null,
    );
  }
}
