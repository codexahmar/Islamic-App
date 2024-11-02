import 'package:flutter/material.dart';
import 'ad_manager.dart';

mixin AdStateMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    AdManager.loadRandomAd();
  }

  @override
  void dispose() {
    super.dispose();
  }
} 