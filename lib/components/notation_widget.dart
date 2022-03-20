import 'package:flutter/material.dart';

class NotationWidget extends StatefulWidget {
  const NotationWidget({this.onUp, this.onDown, Key? key}) : super(key: key);

  final VoidCallback? onUp;
  final VoidCallback? onDown;

  @override
  _NotationWidgetState createState() => _NotationWidgetState();
}

class _NotationWidgetState extends State<NotationWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: widget.onUp,
          icon: Icon(Icons.thumb_up),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '0',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: widget.onDown,
          icon: Icon(Icons.thumb_down),
        ),
      ],
    );
  }
}
