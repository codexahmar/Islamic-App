import 'package:flutter/material.dart';

import 'package:quran/quran.dart' as quran;

import 'package:quran_app/UI/Screens/juzz_details.dart';

class JuzzListScreen extends StatefulWidget {
  const JuzzListScreen({super.key});

  @override
  State<JuzzListScreen> createState() => _JuzzListScreenState();
}

class _JuzzListScreenState extends State<JuzzListScreen> {
  List<Map<String, dynamic>> juzzDetails = [];

  final Color primaryColor = Color(0xFF0E7C7B); // Updated primary color
  final Color accentColor = Color(0xFFF4A261); // New accent color (orange)
  final Color backgroundColor = Color(0xFFF5F5F5); // Light grey background

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Juz List',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor.withOpacity(0.1), backgroundColor],
          ),
        ),
        child: ListView.builder(
          itemCount: juzzDetails.length,
          padding: const EdgeInsets.all(16.0),
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
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JuzDetailScreen(juzNumber: juzNumber),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: primaryColor,
                            child: Text(
                              "$juzNumber",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            "Juz $juzNumber",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        surahDetails,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
