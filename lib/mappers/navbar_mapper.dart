import 'package:flutter/material.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;

class NavbarMapper {
  List<NavbarLink> get items => <NavbarLink>[
        const NavbarLink(name: 'Épisodes', icon: Icon(Icons.subscriptions)),
        const NavbarLink(name: 'Scans', icon: Icon(Icons.library_books)),
        const NavbarLink(name: 'Animes', icon: Icon(Icons.live_tv)),
        if (member_mapper.isConnected())
          const NavbarLink(
              name: 'Watchlist', icon: Icon(Icons.playlist_add_check)),
        const NavbarLink(name: 'Paramètres', icon: Icon(Icons.settings)),
      ];
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
