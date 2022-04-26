import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/utils/utils.dart';

class ScanList extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Widget> children;

  const ScanList({
    this.scrollController,
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isOnMobile(context)) {
      return GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 4,
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
