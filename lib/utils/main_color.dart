import 'dart:ui';

class MainColor {
  static const int mainColor = 0xFFf6a65f;
  static const int redMainColor = 246;
  static const int greenMainColor = 166;
  static const int blueMainColor = 95;
  static const Color mainColorO = Color.fromRGBO(
    redMainColor,
    greenMainColor,
    blueMainColor,
    1.0,
  );

  static final Map<int, Color> mainColors = {
    50: const Color.fromRGBO(
      redMainColor,
      greenMainColor,
      blueMainColor,
      .1,
    ),
    100: const Color.fromRGBO(
      redMainColor,
      greenMainColor,
      blueMainColor,
      .2,
    ),
    200: const Color.fromRGBO(
      redMainColor,
      greenMainColor,
      blueMainColor,
      .3,
    ),
    300: const Color.fromRGBO(
      redMainColor,
      greenMainColor,
      blueMainColor,
      .4,
    ),
    400: const Color.fromRGBO(
      redMainColor,
      greenMainColor,
      blueMainColor,
      .5,
    ),
    500: const Color.fromRGBO(
      redMainColor,
      greenMainColor,
      blueMainColor,
      .6,
    ),
    600: const Color.fromRGBO(
      redMainColor,
      greenMainColor,
      blueMainColor,
      .7,
    ),
    700: const Color.fromRGBO(
      redMainColor,
      greenMainColor,
      blueMainColor,
      .8,
    ),
    800: const Color.fromRGBO(
      redMainColor,
      greenMainColor,
      blueMainColor,
      .9,
    ),
    900: const Color.fromRGBO(
      redMainColor,
      greenMainColor,
      blueMainColor,
      1,
    ),
  };
}
