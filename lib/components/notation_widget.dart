import 'package:flutter/material.dart';

class NotationWidget extends StatefulWidget {
  final VoidCallback? onUp;
  final Color? colorUp;
  final int? up;
  final VoidCallback? onDown;
  final Color? colorDown;

  const NotationWidget({
    this.onUp,
    this.colorUp,
    this.up,
    this.onDown,
    this.colorDown,
    Key? key,
  }) : super(key: key);

  @override
  _NotationWidgetState createState() => _NotationWidgetState();
}

class _NotationWidgetState extends State<NotationWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 7.5),
          child: GestureDetector(
            onTap: widget.onUp,
            child: Icon(
              Icons.thumb_up,
              color: widget.colorUp ?? Colors.grey,
            ),
          ),
        ),
        Text(
          '${widget.up ?? 0}',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7.5),
          child: GestureDetector(
            onTap: widget.onDown,
            child: Icon(
              Icons.thumb_down,
              color: widget.colorDown ?? Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
