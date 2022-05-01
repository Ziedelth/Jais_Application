import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomGestureDetector extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Function()? onLongPress;

  const CustomGestureDetector({
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () =>
              LongPressGestureRecognizer(debugOwner: this, duration: duration),
          (LongPressGestureRecognizer instance) {
            instance.onLongPress = onLongPress;
          },
        ),
      },
      child: child,
    );
  }
}
