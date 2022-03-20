import 'package:flutter/material.dart';

class NotationWidget extends StatefulWidget {
  const NotationWidget({Key? key}) : super(key: key);

  @override
  _NotationWidgetState createState() => _NotationWidgetState();
}

class _NotationWidgetState extends State<NotationWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.thumb_up),
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
        Icon(Icons.thumb_down),
      ],
    );
  }
}
