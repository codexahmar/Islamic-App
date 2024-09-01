import 'package:flutter/material.dart';

import 'package:quran/quran.dart' as quran;

import '../../generated/l10n.dart';
import '../constants/constants.dart';
import 'surah_details_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  @override
  Widget build(BuildContext context) {
    // Fetch the localized strings
    final appLocalizations = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.alQuranTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: quran.totalSurahCount,
          itemBuilder: (context, index) {
            int surahNumber = index + 1;
            String surahName = quran.getSurahName(surahNumber);

            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      "$surahNumber",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  surahName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SurahDetailScreen(surahNumber: surahNumber),
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu_book, color: Colors.white),
                  label: Text(
                    appLocalizations.readNowButton,
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
