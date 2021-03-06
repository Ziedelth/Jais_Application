import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:jais/components/jdialog.dart';
import 'package:jais/components/navbar.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/mappers/navbar_mapper.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/animes_view.dart';
import 'package:jais/views/episodes_view.dart';
import 'package:jais/views/settings_view.dart';
import 'package:jais/views/watchlist_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _navbarMapper = NavbarMapper();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await member_mapper.loginWithToken();

      if (await needsToShowReview()) {
        final sharedPreferences = await SharedPreferences.getInstance();

        if (mounted) {
          show(
            context,
            widget: const Text(
                "Vous avez apprécié notre application ? Merci de laisser un avis."),
            actions: [
              ElevatedButton(
                child: const Text("Laisser un avis"),
                onPressed: () async {
                  Navigator.pop(context);
                  InAppReview.instance.requestReview();
                  await sharedPreferences.setBool('acceptReview', false);
                },
              ),
              ElevatedButton(
                child: const Text("Non merci"),
                onPressed: () async {
                  Navigator.pop(context);
                  await sharedPreferences.setBool('acceptReview', false);
                },
              ),
            ],
          );
        }
      }

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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ChangeNotifierProvider<NavbarMapper>.value(
          value: _navbarMapper,
          child: Consumer<NavbarMapper>(
            builder: (context, navbarMapper, _) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Column(
                  children: [
                    Navbar(
                      navbarMapper: navbarMapper,
                      onPageChanged: (page) => navbarMapper.currentPage = page,
                    ),
                    Expanded(
                      child: PageView(
                        controller: navbarMapper.pageController,
                        onPageChanged: (i) => navbarMapper.currentPage = i,
                        children: <Widget>[
                          const EpisodesView(),
                          const AnimesView(),
                          if (member_mapper.isConnected())
                            const WatchlistView(),
                          SettingsView(
                            onLogin: () => navbarMapper.currentPage = 0,
                            onLogout: () => navbarMapper.currentPage = 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedItemColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Colors.grey,
                  currentIndex: navbarMapper.currentPage,
                  onTap: (index) => navbarMapper.currentPage = index,
                  items: navbarMapper.itemsBottomNavBar,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
