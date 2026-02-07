import 'package:flutter/material.dart';

extension EmptyPadding on num {
  SizedBox get hh => SizedBox(
        height: toDouble(),
      );
  SizedBox get ww => SizedBox(
        width: toDouble(),
      );
}

extension ContextExtensions on BuildContext {
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ColorScheme get color => Theme.of(this).colorScheme;
  // Color get primaryColor => Theme.of(this).primaryColor;

  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
}

extension RemoveSpaces on String {
  String removeSpaces() {
    return replaceAll(' ', '');
  }
}

logs(String message, {bool showPrintInRelease = false}) {
  debugPrint(message);

  if (showPrintInRelease) {
    // ignore: avoid_print
    logs(message);
  }
}