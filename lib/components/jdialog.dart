import 'package:flutter/material.dart';

void show(
  BuildContext context, {
  required Widget widget,
  List<Widget> actions = const [],
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      content: SingleChildScrollView(
        child: widget,
      ),
      actions: actions,
    ),
  );
}
