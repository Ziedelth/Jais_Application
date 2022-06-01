import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DisplayMapper {
  bool isOnMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  bool get isOnWeb => kIsWeb;

  bool get isOnApp => !kIsWeb;

  bool isOnMobileOnWebOrUseApp(BuildContext context) =>
      (isOnWeb && isOnMobile(context)) || isOnApp;
}
