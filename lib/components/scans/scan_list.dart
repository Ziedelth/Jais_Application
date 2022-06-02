import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/utils/utils.dart';

class ScanList extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Widget> children;

  const ScanList({this.scrollController, required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    if (!isOnMobile(context)) {
      final width = MediaQuery.of(context).size.width;

      return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3E-3 * width + 0.0302,
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
