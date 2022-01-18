import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CircularProgressIndicator.adaptive(),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text('Chargement en cours...'),
        ),
      ],
    );
  }
}
