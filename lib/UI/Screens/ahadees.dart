import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Models/hadith_model.dart';
import '../../Services/Ahadees_api_service.dart';
import '../../generated/l10n.dart';
import '../constants/constants.dart';

class Ahadees extends StatefulWidget {
  const Ahadees({super.key});

  @override
  State<Ahadees> createState() => _AhadeesState();
}

class _AhadeesState extends State<Ahadees> {
  late Future<List<Data>> _futureAhadees;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureAhadees = apiService.fetchHadiths();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.ahadees,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<Data>>(
        future: _futureAhadees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final ahadees = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: ahadees.length,
            itemBuilder: (context, index) {
              final hadith = ahadees[index];

              return Container(
                margin: EdgeInsets.only(bottom: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryColor,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Hadith #${hadith.hadithNumber}',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'English Translation:',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hadith.hadithEnglish ?? '',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Urdu Translation:',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hadith.hadithUrdu ?? '',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '[Source: ${hadith.book?.bookName ?? 'Unknown Book'} - ${hadith.chapter?.chapterEnglish ?? 'Unknown Chapter'}]',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 10.89,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff00653A),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
