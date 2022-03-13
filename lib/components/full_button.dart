import 'package:flutter/material.dart';

class FullWidget extends StatelessWidget {
  final Widget widget;
  final Icon? icon;

  const FullWidget({
    required this.widget,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (this.icon != null)
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: this.icon!,
          ),
        Expanded(
          child: widget,
        ),
      ],
    );
  }
}
