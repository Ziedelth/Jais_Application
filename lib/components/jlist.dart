import 'package:flutter/material.dart';

class JList extends StatelessWidget {
  const JList({
    Key? key,
    required this.children,
    this.controller,
    this.direction = Axis.vertical,
  }) : super(key: key);

  final List<Widget> children;
  final ScrollController? controller;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      controller: controller,
      itemCount: children.length,
      scrollDirection: direction,
      itemBuilder: (context, index) => children[index],
    );
  }
}
