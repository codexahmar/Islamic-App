import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
        title: Text(
          localization.fortyRabana,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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

          return ListView.builder(
            itemCount: rabannas.length,
            itemBuilder: (context, index) {
              final rabanna = rabannas[index];

              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Rabanna #${index + 1}',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      textAlign: TextAlign.center,
                      rabanna.arabic,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      textAlign: TextAlign.center,
                      rabanna.translation,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '[Quran: ${rabanna.quran}]',
                          style: GoogleFonts.poppins(
                            fontSize: 10.89,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff00653A),
                          ),
                        ),
                      ],
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
