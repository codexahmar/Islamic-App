import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          localization.ahadees,
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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

          return AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: ahadees.length,
              itemBuilder: (context, index) {
                final hadith = ahadees[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15)),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text(
                                  'Hadith #${hadith.hadithNumber}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'English Translation:',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    hadith.hadithEnglish ?? '',
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    'Urdu Translation:',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    hadith.hadithUrdu ?? '',
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.notoNastaliqUrdu(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '[Source: ${hadith.book?.bookName ?? 'Unknown Book'} - ${hadith.chapter?.chapterEnglish ?? 'Unknown Chapter'}]',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff00653A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
