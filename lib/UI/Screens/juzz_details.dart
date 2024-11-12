import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/UI/constants/constants.dart';

class JuzDetailScreen extends StatelessWidget {
  final int juzNumber;

  const JuzDetailScreen({Key? key, required this.juzNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> juzContent = [];
    int currentSurah = 0;

    for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
      int versesCount = quran.getVerseCount(surahNumber);
      for (int verseNumber = 1; verseNumber <= versesCount; verseNumber++) {
        if (quran.getJuzNumber(surahNumber, verseNumber) == juzNumber) {
          if (currentSurah != surahNumber) {
            if (currentSurah != 0) {
              juzContent.add(const SizedBox(height: 30));
            }
            juzContent.add(SurahTitle(surahNumber: surahNumber));
            currentSurah = surahNumber;
          }
          juzContent.add(
              VerseWidget(surahNumber: surahNumber, verseNumber: verseNumber));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Juz $juzNumber', style: GoogleFonts.lateef(fontSize: 28)),
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: juzContent),
        ),
      ),
    );
  }
}

class SurahTitle extends StatelessWidget {
  final int surahNumber;

  const SurahTitle({Key? key, required this.surahNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryColor, width: 2),
      ),
      child: Column(
        children: [
          Text(
            quran.getSurahNameArabic(surahNumber),
            style: GoogleFonts.scheherazadeNew(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            quran.getSurahNameEnglish(surahNumber),
            style: GoogleFonts.lateef(
              fontSize: 24,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class VerseWidget extends StatelessWidget {
  final int surahNumber;
  final int verseNumber;

  const VerseWidget(
      {Key? key, required this.surahNumber, required this.verseNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            quran.getVerse(surahNumber, verseNumber, verseEndSymbol: true),
            style: GoogleFonts.scheherazadeNew(fontSize: 24),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            '${surahNumber}:${verseNumber}',
            style: GoogleFonts.lateef(
              fontSize: 18,
              color: primaryColor,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
