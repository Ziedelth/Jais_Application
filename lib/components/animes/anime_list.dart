import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/display_mapper.dart';

class AnimeList extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Widget> children;

  const AnimeList({this.scrollController, required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    if (!DisplayMapper.instance.isOnMobile(context)) {
      final width = MediaQuery.of(context).size.width;

      return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.28E-3 * width + 0.0772,
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
