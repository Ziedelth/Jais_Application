import 'package:flutter/material.dart';

class JList extends StatelessWidget {
  const JList({Key? key, required this.children, this.controller})
      : super(key: key);

  final List<Widget> children;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      controller: controller,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
