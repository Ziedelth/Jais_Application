import 'package:flutter/material.dart';

class DisplayMapper {
  static final instance = DisplayMapper();

  bool isOnMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
}
