import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asmaulhusna/asmaulhusna.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../generated/l10n.dart';
import '../constants/constants.dart';

class AllahNames extends StatefulWidget {
  const AllahNames({super.key});

  @override
  State<AllahNames> createState() => _AllahNamesState();
}

class _AllahNamesState extends State<AllahNames> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleAudioPlayback() async {
    try {
      print('Attempting to play audio from: assets/audio/Allah-names.mp3');
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(AssetSource('audio/Allah-names.mp3'));
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.appBarTitle,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 99,
              itemBuilder: (context, index) {
                final englishName = getEnglishName(index + 1);
                final arabicName = getArabicName(index + 1);

                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      englishName,
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      arabicName,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.sectionTitle,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      localization.sectionSubtitle,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: _toggleAudioPlayback,
                ),
              ],
            ),
            padding: EdgeInsets.all(22),
          ),
        ],
      ),
    );
  }
}
