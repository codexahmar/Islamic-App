import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

Future<List<Rabanna>> loadRabannas() async {
  // Get the current locale
  String locale = Intl.getCurrentLocale();
  String fileName;

  // Determine the correct JSON file based on the current locale
  if (locale.startsWith('ur')) {
    fileName = 'rabannas_ur.json';
  } else if (locale.startsWith('tr')) {
    fileName = 'rabannas_tr.json';
  } else {
    fileName = 'rabannas_en.json';
  }

  try {
    // Load the JSON file from assets
    final String response =
        await rootBundle.loadString('assets/json/$fileName');

    // Decode the JSON data
    final List<dynamic> data = json.decode(response);

    // Map the JSON data to Rabanna objects and return the list
    return data.map((item) => Rabanna.fromJson(item)).toList();
  } catch (e) {
    // Handle errors, such as file not found or JSON decoding issues
    print("Error loading Rabannas: $e");
    return [];
  }
}

class Rabanna {
  final int number;
  final String arabic;
  final String translation;
  final String quran;

  Rabanna({
    required this.number,
    required this.arabic,
    required this.translation,
    required this.quran,
  });

  factory Rabanna.fromJson(Map<String, dynamic> json) {
    return Rabanna(
      number: json['number'],
      arabic: json['arabic'],
      translation: json['translation'],
      quran: json['quran'],
    );
  }
}
