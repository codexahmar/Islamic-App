import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/Models/daily_azkar_model.dart';

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
      appBar: AppBar(
        title: Text(
          localization.dailyAzkar,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
          return ListView.builder(
            itemCount: azkars.length,
            itemBuilder: (context, index) {
              final azkar = azkars[index];
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          azkar.title,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      azkar.dua,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      azkar.translation,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Benefits: ${azkar.benefits}",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.green[600],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Time to Recite: ${azkar.time_to_recite}",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue[600],
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
