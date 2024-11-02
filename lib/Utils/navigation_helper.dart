import 'package:flutter/material.dart';
import 'ad_manager.dart';

class NavigationHelper {
  static Future<T?> pushScreen<T>(BuildContext context, Widget screen) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((value) {
      AdManager.loadRandomAd();
      return value;
    });
  }
}
