import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Future<List<Kalimas>> loadKalimas() async {
  String locale = Intl.getCurrentLocale();
  String fileName;

  // Determine the correct JSON file based on the current locale
  if (locale.startsWith('ur')) {
    fileName = 'six_kalimas_ur.json';
  } else if (locale.startsWith('tr')) {
    fileName = 'six_kalimas_tr.json';
  } else {
    fileName = 'six_kalimas_en.json';
  }

  // Load the JSON file from assets
  final String response = await rootBundle.loadString('assets/json/$fileName');
  
  // Decode the JSON data
  final List<dynamic> data = json.decode(response);
  
  // Map the JSON data to Kalimas objects and return the list
  return data.map((item) => Kalimas.fromJson(item)).toList();
}

class Kalimas {
  final String title;
  final String arabic;
  final String translation;

  Kalimas(
      {required this.title, required this.arabic, required this.translation});
  factory Kalimas.fromJson(Map<String, dynamic> json) {
    return Kalimas(
        title: json["title"],
        arabic: json["arabic"],
        translation: json["translation"]);
  }
}
