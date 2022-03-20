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
        GestureDetector(
          child: Icon(
            Icons.thumb_up,
            color: Colors.grey,
          ),
          onTap: widget.onUp,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${widget.up ?? 0}',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        GestureDetector(
          child: Icon(
            Icons.thumb_down,
            color: Colors.grey,
          ),
          onTap: widget.onDown,
        ),
      ],
    );
  }
}
