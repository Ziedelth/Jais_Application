import 'package:flutter/material.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/utils/utils.dart';

class NavbarMapper extends ChangeNotifier {
  static final instance = NavbarMapper();
  late final PageController pageController;

  NavbarMapper({int defaultPage = 0})
      : pageController = PageController(initialPage: defaultPage);

  int get currentPage {
    try {
      return pageController.page?.toInt() ?? 0;
    } catch (e) {
      return 0;
    }
  }

  set currentPage(int page) {
    pageController.jumpToPage(page);
    notifyListeners();
    clearImagesCache();
  }

  List<NavbarLink> get items => <NavbarLink>[
        const NavbarLink(
          name: 'Épisodes',
          icon: Icon(Icons.subscriptions),
        ),
        const NavbarLink(
          name: 'Animes',
          icon: Icon(Icons.live_tv),
        ),
        if (MemberMapper.instance.isConnected())
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

  List<Widget> itemsTopNavBar([Function(int)? callback]) => items
      .asMap()
      .map(
        (i, e) => MapEntry(
          i,
          e.toTextButton(onPressed: () => callback?.call(i)),
        ),
      )
      .values
      .toList();
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
