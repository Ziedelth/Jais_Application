import 'package:flutter/material.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;

class NavbarMapper {
  final PageController pageController = PageController();

  int get currentPage {
    try {
      return pageController.page?.toInt() ?? 0;
    } catch (e) {
      return 0;
    }
  }

  set currentPage(int page) => pageController.jumpToPage(page);

  List<NavbarLink> get items => <NavbarLink>[
        const NavbarLink(
          name: 'Épisodes',
          icon: Icon(Icons.subscriptions),
        ),
        const NavbarLink(
          name: 'Scans',
          icon: Icon(Icons.library_books),
        ),
        const NavbarLink(
          name: 'Animes',
          icon: Icon(Icons.live_tv),
        ),
        if (member_mapper.isConnected())
          const NavbarLink(
            name: 'Watchlist',
            icon: Icon(Icons.playlist_add_check),
          ),
        const NavbarLink(
          name: 'Paramètres',
          icon: Icon(Icons.settings),
        ),
      ];

  List<BottomNavigationBarItem> get itemsBottomNavBar =>
      items.map((e) => e.toBottomNavigationBarItem()).toList();
}

class NavbarLink {
  final String name;
  final Icon icon;

  const NavbarLink({
    required this.name,
    required this.icon,
  });

  BottomNavigationBarItem toBottomNavigationBarItem() =>
      BottomNavigationBarItem(
        icon: icon,
        label: name,
      );

  TextButton toTextButton({Function()? onPressed}) => TextButton(
        onPressed: onPressed,
        child: Text(name),
      );
}
