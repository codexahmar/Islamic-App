import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Tasbeeh>> loadTasbeeh() async {
  String locale = Intl.getCurrentLocale();
  String fileName;

  if (locale.startsWith('ur')) {
    fileName = 'tasbeeh_ur.json';
  } else if (locale.startsWith('tr')) {
    fileName = 'tasbeeh_tr.json';
  } else {
    fileName = 'tasbeeh_en.json';
  }

  final String response = await rootBundle.loadString('assets/json/$fileName');
  final List<dynamic> data = json.decode(response);
  return data.map((item) => Tasbeeh.fromJson(item)).toList();
}

class Tasbeeh {
  final String name;
  final String arabic;
  final String translation;
  final int count;
  int currentCount;

  Tasbeeh({
    required this.name,
    required this.arabic,
    required this.translation,
    required this.count,
    this.currentCount = 0,
  });

  factory Tasbeeh.fromJson(Map<String, dynamic> json) {
    return Tasbeeh(
      name: json['name'],
      arabic: json['arabic'],
      translation: json['translation'],
      count: json['count'],
    );
  }

  Future<void> saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(name, currentCount);
  }

  Future<void> loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    currentCount = prefs.getInt(name) ?? 0;
  }
}
