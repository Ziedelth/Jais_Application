import 'package:flutter/material.dart';

class NotationWidget extends StatefulWidget {
  const NotationWidget({this.onUp, this.up, this.onDown, Key? key})
      : super(key: key);

  final VoidCallback? onUp;
  final int? up;
  final VoidCallback? onDown;

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
            child: const Icon(
              Icons.thumb_up,
              color: Colors.grey,
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
            child: const Icon(
              Icons.thumb_down,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
