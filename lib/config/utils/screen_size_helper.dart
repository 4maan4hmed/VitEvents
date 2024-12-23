import 'package:flutter/material.dart';

/// Helper class for responsive sizing
class ScreenSizeHelper {
  final BuildContext context;

  ScreenSizeHelper(this.context);

  double height(double percentage) =>
      MediaQuery.of(context).size.height * (percentage / 100);

  double width(double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);
}