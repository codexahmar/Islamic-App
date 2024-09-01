import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

Future<List<Azkars>> loadAzkars() async {
  // Get the current locale
  String locale = Intl.getCurrentLocale();
  String fileName;

  // Determine the JSON file based on the locale
  if (locale.startsWith('ur')) {
    fileName = 'daily_azkar_ur.json';
  } else if (locale.startsWith('tr')) {
    fileName = 'daily_azkar_tr.json';
  } else {
    fileName = 'daily_azkar_en.json';
  }

  // Load and decode the JSON file
  final String response = await rootBundle.loadString('assets/json/$fileName');
  final List<dynamic> data = json.decode(response);

  // Convert the JSON data to a list of Azkars objects
  return data.map((item) => Azkars.fromJson(item)).toList();
}

class Azkars {
  final String title;
  final String dua;
  final String translation;
  final String benefits;
  final String time_to_recite;

  Azkars(
      {required this.title,
      required this.dua,
      required this.translation,
      required this.benefits,
      required this.time_to_recite});
  factory Azkars.fromJson(Map<String, dynamic> json) {
    return Azkars(
        title: json["title"],
        dua: json["dua"],
        translation: json["translation"],
        benefits: json["benefits"],
        time_to_recite: json["time_to_recite"]);
  }
}
