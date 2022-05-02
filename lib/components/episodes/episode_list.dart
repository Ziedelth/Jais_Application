import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/utils/utils.dart';

class EpisodeList extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Widget> children;

  const EpisodeList({
    this.scrollController,
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isOnMobile(context)) {
      final width = MediaQuery.of(context).size.width;

      return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // childAspectRatio: (width * 1.125) / 1245,
          // childAspectRatio: 4.95E-4 * width + 0.514,
          childAspectRatio: -1.9 + 0.42 * log(width),
          // childAspectRatio: 1.285,
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
