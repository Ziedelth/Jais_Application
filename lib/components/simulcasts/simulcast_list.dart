import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/models/simulcast.dart';

class SimulcastList extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Widget> children;
  final Simulcast? simulcast;

  const SimulcastList({
    required this.children,
    this.scrollController,
    this.simulcast,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return JList(
      direction: Axis.horizontal,
      controller: scrollController,
      children: children,
    );
  }
}
