import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        title: Text(
          localization.sixKalima,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
          return ListView.builder(
              itemCount: kalimas.length,
              itemBuilder: (context, index) {
                final kalima = kalimas[index];
                return Container(
                  padding: const EdgeInsets.all(16.0),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              kalima.title,
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
                        textAlign: TextAlign.center,
                        kalima.arabic,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        textAlign: TextAlign.center,
                        kalima.translation,
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
