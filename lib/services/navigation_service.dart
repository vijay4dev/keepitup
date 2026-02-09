import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState? get _navigator => navigatorKey.currentState;

  /// Push new screen
  static Future<T?> push<T>(Widget page) {
    return _navigator!.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Replace current screen
  static Future<T?> pushReplacement<T>(Widget page) {
    return _navigator!.pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Clear stack & go to screen
  static Future<T?> pushAndRemoveAll<T>(Widget page) {
    return _navigator!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Go back
  static void pop<T>([T? result]) {
    _navigator!.pop(result);
  }
}
