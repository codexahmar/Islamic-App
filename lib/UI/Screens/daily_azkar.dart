import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/Models/daily_azkar_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../generated/l10n.dart';
import '../constants/constants.dart';

class DailyAzkar extends StatefulWidget {
  const DailyAzkar({super.key});

  @override
  State<DailyAzkar> createState() => _DailyAzkarState();
}

class _DailyAzkarState extends State<DailyAzkar> {
  late Future<List<Azkars>> _futureAzkars;

  @override
  void initState() {
    super.initState();
    _futureAzkars = loadAzkars();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          localization.dailyAzkar,
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
      body: FutureBuilder<List<Azkars>>(
        future: _futureAzkars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }
          final azkars = snapshot.data!;
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: azkars.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final azkar = azkars[index];
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
                        child: ExpansionTile(
                          title: Text(
                            azkar.title,
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    azkar.dua,
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.amiri(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    azkar.translation,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  _buildInfoChip(
                                      Icons.star, azkar.benefits, Colors.amber),
                                  SizedBox(height: 10),
                                  _buildInfoChip(Icons.access_time,
                                      azkar.time_to_recite, Colors.blue),
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

  Widget _buildInfoChip(IconData icon, String value, Color color) {
    return Chip(
      avatar: Icon(icon, color: color, size: 16),
      label: Text(
        value,
        style: GoogleFonts.roboto(fontSize: 14, color: Colors.black87),
      ),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}
