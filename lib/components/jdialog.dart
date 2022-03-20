import 'package:flutter/material.dart';
import 'package:jais/utils/main_color.dart';

class JDialog {
  static void show(BuildContext context,
      {List<Widget> children = const [], List<Widget> actions = const []}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: MainColor.mainColorO),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: children,
          ),
        ),
        actions: actions,
      ),
    );
  }
}
