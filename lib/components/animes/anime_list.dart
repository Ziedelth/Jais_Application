import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/display_mapper.dart';

class AnimeList extends StatelessWidget {
  final _displayMapper = DisplayMapper();
  final ScrollController? scrollController;
  final List<Widget> children;

  AnimeList({this.scrollController, required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    if (!_displayMapper.isOnMobile(context)) {
      final width = MediaQuery.of(context).size.width;

      return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.3E-3 * width + 0.0772,
        ),
        controller: scrollController,
        children: children,
      );
    }

    return JList(
      controller: scrollController,
      children: children,
    );
  }
}
