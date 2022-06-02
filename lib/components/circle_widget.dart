import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  final Widget widget;

  const CircleWidget({required this.widget, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(360),
      child: widget,
    );
  }
}
