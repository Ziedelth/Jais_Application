import 'package:flutter/material.dart';

class FullWidget extends StatelessWidget {
  final Widget widget;
  final Icon? icon;

  const FullWidget({required this.widget, this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Padding(padding: const EdgeInsets.only(right: 10), child: icon),
        Expanded(child: widget),
      ],
    );
  }
}
