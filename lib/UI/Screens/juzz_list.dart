import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;

import '../../generated/l10n.dart';

class JuzzListScreen extends StatefulWidget {
  const JuzzListScreen({super.key});

  @override
  State<JuzzListScreen> createState() => _JuzzListScreenState();
}

class _JuzzListScreenState extends State<JuzzListScreen> {
  List<Map<String, dynamic>> juzzDetails = [];

  @override
  void initState() {
    super.initState();
    _initializeJuzzDetails();
  }

  void _initializeJuzzDetails() {
    for (int i = 1; i <= 30; i++) {
      Map<int, List<int>> surahAndVerses = quran.getSurahAndVersesFromJuz(i);
      juzzDetails.add({
        'juzNumber': i,
        'surahAndVerses': surahAndVerses,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.appBarTitle,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: juzzDetails.length,
        padding: const EdgeInsets.all(12.0),
        itemBuilder: (context, index) {
          int juzNumber = juzzDetails[index]['juzNumber'];
          Map<int, List<int>> surahAndVerses =
              juzzDetails[index]['surahAndVerses'];
          String surahDetails = surahAndVerses.entries.map((entry) {
            String surahName = quran.getSurahName(entry.key);
            String verses = entry.value.join(', ');
            return "$surahName: Ayahs $verses";
          }).join("\n");

          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                child: Text(
                  "$juzNumber",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              title: Text(
                "Juz $juzNumber",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Title text color
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  surahDetails,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87, // Subtitle text color
                  ),
                ),
              ),
              onTap: () {
                // Navigate to the detailed view of the selected Juz, if required.
              },
            ),
          );
        },
      ),
    );
  }
}
