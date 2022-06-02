import 'package:flutter/material.dart';

class RoundBorderWidget extends StatelessWidget {
  final Widget widget;

  const RoundBorderWidget({required this.widget, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: widget,
    );
  }
}
