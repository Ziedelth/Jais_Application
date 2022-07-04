import 'package:flutter/material.dart';

class DisplayMapper {
  bool isOnMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
}
