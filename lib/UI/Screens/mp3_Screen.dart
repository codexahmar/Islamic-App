import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/UI/Screens/playback_screen.dart';
import 'package:quran_app/UI/constants/constants.dart';
import 'package:quran_app/Utils/ad_manager.dart';
import 'package:quran_app/Utils/ad_state_mixin.dart';
import 'package:quran_app/Utils/navigation_helper.dart';

import 'dart:io';

import '../../generated/l10n.dart';

class Mp3Screen extends StatefulWidget {
  const Mp3Screen({super.key});

  @override
  State<Mp3Screen> createState() => _Mp3ScreenState();
}

class _Mp3ScreenState extends State<Mp3Screen> with AdStateMixin<Mp3Screen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingSurah;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _audioPlayer.positionStream.listen((Duration position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    _audioPlayer.durationStream.listen((Duration? duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration ?? Duration.zero;
        });
      }
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _playNextSurah();
      }
    });

    // Load the last played surah if any
    _loadLastPlayedSurah();
  }

  Future<void> _playSurah(int surahNumber) async {
    try {
      // Reset the current position to 0
      setState(() {
        _currentPosition = Duration.zero;
      });

      // Get the audio URL of the selected Surah
      String audioUrl = quran.getAudioURLBySurah(surahNumber);
      print("Playing audio from: $audioUrl");

      // Load the new Surah audio
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(audioUrl)),
        initialPosition: _currentPosition, // Start from the beginning
      );
      _audioPlayer.play();

      // Update the UI to reflect the new Surah being played
      setState(() {
        _playingSurah = surahNumber;
        _isPlaying = true;
      });
    } on PlatformException catch (e) {
      print("Error playing audio: ${e.message}");
    }
  }

  Future<void> _stopSurah() async {
    await _audioPlayer.stop();
    setState(() {
      _playingSurah = null;
      _isPlaying = false;
    });
  }

  Future<void> _loadLastPlayedSurah() async {
    // Placeholder for loading the last played surah
    // You can implement a method to fetch and play the last played surah if needed
    // For now, this method does nothing
  }

  Future<void> _seekTo(double value) async {
    Duration newPosition = Duration(seconds: value.toInt());
    await _audioPlayer.seek(newPosition);
    setState(() {
      _currentPosition = newPosition;
    });
  }

  void _playPreviousSurah() {
    if (_playingSurah != null && _playingSurah! > 1) {
      _playSurah(_playingSurah! - 1);
    }
  }

  void _playNextSurah() {
    if (_playingSurah != null && _playingSurah! < quran.totalSurahCount) {
      _playSurah(_playingSurah! + 1);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show ad when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdManager.showAdIfAvailable();
    });

    final localizations = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.mp3Title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: quran.totalSurahCount,
              itemBuilder: (context, index) {
                int surahNumber = index + 1;
                String surahName = quran.getSurahName(surahNumber);

                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Center(
                        child: Text(
                          "$surahNumber",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      surahName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _playingSurah == surahNumber
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            _playingSurah == surahNumber
                                ? localizations.pause
                                : localizations.play,
                            style: const TextStyle(
                              fontSize: 14.14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      if (await checkInternetConnectivity()) {
                        if (_playingSurah == surahNumber) {
                          _stopSurah();
                        } else {
                          NavigationHelper.pushScreen(
                            context,
                            PlaybackScreen(
                              surahName: surahName,
                              audioUrl: quran.getAudioURLBySurah(surahNumber),
                              autoPlay: true,
                              currentSurahNumber: surahNumber,
                            ),
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("No Internet Connection"),
                              content: Text(
                                  "Please check your internet connection and try again."),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Retry"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    checkInternetConnectivity()
                                        .then((connected) {
                                      if (connected) {
                                        if (_playingSurah == surahNumber) {
                                          _stopSurah();
                                        } else {
                                          NavigationHelper.pushScreen(
                                            context,
                                            PlaybackScreen(
                                              surahName: surahName,
                                              audioUrl:
                                                  quran.getAudioURLBySurah(
                                                      surahNumber),
                                              autoPlay: true,
                                              currentSurahNumber: surahNumber,
                                            ),
                                          );
                                        }
                                      }
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Text(localizations.cancel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
          if (_playingSurah != null) _buildPlaybackControls(localizations),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls(localizations) {
    String currentSurahName =
        _playingSurah != null ? quran.getSurahName(_playingSurah!) : '';

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display the name of the currently playing Surah
          if (currentSurahName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "${localizations.surah} $currentSurahName",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Slider(
            activeColor: primaryColor,
            value: (_totalDuration.inSeconds > 0)
                ? _currentPosition.inSeconds.toDouble()
                : 0.0,
            max: (_totalDuration.inSeconds > 0)
                ? _totalDuration.inSeconds.toDouble()
                : 1.0,
            onChanged: (_totalDuration.inSeconds > 0)
                ? _seekTo
                : null, // Disable interaction if there's no valid duration
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currentPosition.toString().split('.').first,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _totalDuration.toString().split('.').first,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: _playPreviousSurah,
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  if (_isPlaying) {
                    _audioPlayer.pause();
                  } else {
                    _audioPlayer.play();
                  }
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: _playNextSurah,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Add this method to check internet connectivity
  Future<bool> checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
