import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/components/custom_gesture_detector.dart';
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
      if (_displayMapper.isOnApp) createGlobalBanner();
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
                    if (_displayMapper.isOnApp)
                      Expanded(
                        child: globalBannerAd != null
                            ? AdWidget(ad: globalBannerAd!)
                            : Container(
                                color: Theme.of(context).backgroundColor,
                              ),
                      ),
                    if (_displayMapper.isOnWeb) ...[
                      const Spacer(),
                      if (!_displayMapper.isOnMobile(context))
                        ..._navbarMapper.items
                            .asMap()
                            .map(
                              (i, e) => MapEntry(
                                i,
                                e.toTextButton(
                                  onPressed: () => _navbarMapper.pageController
                                      .jumpToPage(i),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                      const Spacer()
                    ],
                    const SizedBox(width: 10),
                    if (_navbarMapper.currentPage == 2)
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
                controller: _navbarMapper.pageController,
                onPageChanged: (i) =>
                    setState(() => _navbarMapper.currentPage = i),
                children: <Widget>[
                  EpisodesView(),
                  ScansView(),
                  AnimesView(key: _animesKey),
                  if (member_mapper.isConnected()) const WatchlistView(),
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
              onTap: (index) => _navbarMapper.pageController.jumpToPage(index),
              items: _navbarMapper.itemsBottomNavBar,
            )
          : null,
    );
  }
}
