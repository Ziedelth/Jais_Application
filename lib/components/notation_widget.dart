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
          padding: EdgeInsets.only(right: 7.5),
          child: GestureDetector(
            child: Icon(
              Icons.thumb_up,
              color: Colors.grey,
            ),
            onTap: widget.onUp,
          ),
        ),
        Text(
          '${widget.up ?? 0}',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7.5),
          child: GestureDetector(
            child: Icon(
              Icons.thumb_down,
              color: Colors.grey,
            ),
            onTap: widget.onDown,
          ),
        ),
      ],
    );
  }
}
