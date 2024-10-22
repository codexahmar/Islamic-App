import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_app/Models/kalimas_model.dart';

import '../../generated/l10n.dart';
import '../constants/constants.dart';

class SixKalimaScreen extends StatefulWidget {
  const SixKalimaScreen({super.key});

  @override
  State<SixKalimaScreen> createState() => _SixKalimaScreenState();
}

class _SixKalimaScreenState extends State<SixKalimaScreen> {
  late Future<List<Kalimas>> _futureKalimas;
  @override
  void initState() {
    super.initState();
    _futureKalimas = loadKalimas();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          localization.sixKalima,
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
      body: FutureBuilder<List<Kalimas>>(
        future: _futureKalimas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          final kalimas = snapshot.data!;
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: kalimas.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final kalima = kalimas[index];
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
                                  kalima.title,
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
                                    kalima.arabic,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.amiri(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    kalima.translation,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey[600],
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
