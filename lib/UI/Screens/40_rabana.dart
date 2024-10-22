import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Models/rabanna_model.dart';
import '../../generated/l10n.dart';
import '../constants/constants.dart';

class FortyRabana extends StatefulWidget {
  const FortyRabana({super.key});

  @override
  State<FortyRabana> createState() => _FortyRabanaState();
}

class _FortyRabanaState extends State<FortyRabana> {
  late Future<List<Rabanna>> _futureRabannas;

  @override
  void initState() {
    super.initState();
    _futureRabannas = loadRabannas();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          localization.fortyRabana,
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
      body: FutureBuilder<List<Rabanna>>(
        future: _futureRabannas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final rabannas = snapshot.data!;

          return AnimationLimiter(
            child: ListView.builder(
              itemCount: rabannas.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final rabanna = rabannas[index];
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
                                  'Rabanna #${index + 1}',
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
                                    rabanna.arabic,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.amiri(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    rabanna.translation,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '[Quran: ${rabanna.quran}]',
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
