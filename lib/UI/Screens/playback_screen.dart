import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Import the just_audio package

import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:just_audio_background/just_audio_background.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shimmer/shimmer.dart'; // Add this import

class PlaybackScreen extends StatefulWidget {
  final String surahName; // Add a field for the surah name
  final String audioUrl; // Add a field for the audio URL
  final bool autoPlay; // Add a field to control autoplay
  final int currentSurahNumber; // Add this line

  const PlaybackScreen({
    super.key,
    required this.surahName,
    required this.audioUrl,
    this.autoPlay = false,
    required this.currentSurahNumber, // Add this line
  });

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Create an instance of AudioPlayer
  bool isPlaying = false;
  double playbackPosition = 0.0;
  late int currentSurahNumber; // Add this line
  bool _isLoading = true; // Add this line
  late ConcatenatingAudioSource _playlist;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide system UI
    currentSurahNumber = widget.currentSurahNumber; // Add this line
    _initializePlaylist(); // Initialize the playlist
    if (widget.autoPlay) {
      // Check if autoPlay is true
      playAudio(); // Start playing audio immediately
    }

    // Add this listener
    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        isPlaying = playerState.playing;
      });
    });

    // Listen for audio player state changes
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        setState(() {
          currentSurahNumber = index + widget.currentSurahNumber;
        });
        print("Now playing surah: $currentSurahNumber");
      }
    });
  }

  Future<void> _initializePlaylist() async {
    setState(() => _isLoading = true);
    try {
      final List<AudioSource> audioSources = [];
      for (int i = widget.currentSurahNumber; i <= quran.totalSurahCount; i++) {
        audioSources.add(
          AudioSource.uri(
            Uri.parse(quran.getAudioURLBySurah(i)),
            tag: MediaItem(
              id: i.toString(),
              album: "Quran",
              title: quran.getSurahName(i),
              artUri: Uri.parse('asset:///assets/images/qari.png'),
            ),
          ),
        );
      }
      _playlist = ConcatenatingAudioSource(children: audioSources);
      await _audioPlayer.setAudioSource(_playlist);
      print("Playlist initialized successfully");
    } catch (e) {
      print("Error initializing playlist: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void playAudio() {
    _audioPlayer.play();
    setState(() {
      isPlaying = true;
    });
  }

  void pauseAudio() {
    _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void skipForward() {
    _audioPlayer.seek(_audioPlayer.position +
        Duration(seconds: 10)); // Skip forward 10 seconds
  }

  void skipBackward() {
    final newPosition =
        _audioPlayer.position - Duration(seconds: 10); // Calculate new position
    _audioPlayer.seek(newPosition < Duration.zero
        ? Duration.zero
        : newPosition); // Ensure it doesn't go below 0
  }

  void playNextSurah() {
    if (_audioPlayer.hasNext) {
      _audioPlayer.seekToNext();
    } else {
      print("Reached the end of Quran");
    }
  }

  void playPreviousSurah() {
    if (_audioPlayer.hasPrevious) {
      _audioPlayer.seekToPrevious();
    } else {
      print("Already at the first surah");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player when done
    super.dispose();
  }

  Widget _buildShimmer(Widget child) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[600]!,
      highlightColor: Colors.white,
      period:
          Duration(milliseconds: 1500), // Slower animation for more visibility
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Set a background color
      appBar: AppBar(
        title: const Text(
          "MP3 Quran",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors
            .blueGrey[900], // Updated to match the Scaffold background color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Allow scrolling
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center align
            children: [
              SizedBox(height: 40),
              _isLoading
                  ? _buildShimmer(Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ))
                  : Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage("assets/images/qari.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              SizedBox(height: 40),
              Text(
                quran.getSurahName(currentSurahNumber),
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                isPlaying ? "Now Playing" : "Paused",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70),
              ),
              SizedBox(height: 40),
              _buildPlayerControls(),
              SizedBox(height: 24),
              _buildProgressBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.skip_previous, color: Colors.white70),
          onPressed: playPreviousSurah,
          iconSize: 36,
        ),
        IconButton(
          icon: Icon(Icons.replay_10, color: Colors.white70),
          onPressed: skipBackward,
          iconSize: 36,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 25,
              color: Colors.blueGrey[900],
            ),
            onPressed: isPlaying ? pauseAudio : playAudio,
          ),
        ),
        IconButton(
          icon: Icon(Icons.forward_10, color: Colors.white70),
          onPressed: skipForward,
          iconSize: 36,
        ),
        IconButton(
          icon: Icon(Icons.skip_next, color: Colors.white70),
          onPressed: playNextSurah,
          iconSize: 36,
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        StreamBuilder<Duration>(
          stream: _audioPlayer.positionStream,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            return Slider(
              activeColor: Colors.amber,
              inactiveColor: Colors.white24,
              value: position.inSeconds
                  .clamp(0, _audioPlayer.duration?.inSeconds ?? 0)
                  .toDouble(), // Clamp the value
              min: 0.0,
              max: _audioPlayer.duration?.inSeconds.toDouble() ?? 1.0,
              onChanged: (value) {
                setState(() {
                  playbackPosition = value;
                });
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (context, positionSnapshot) {
              final currentPosition = positionSnapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                stream: _audioPlayer.durationStream,
                builder: (context, durationSnapshot) {
                  final totalDuration = durationSnapshot.data ?? Duration.zero;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(currentPosition),
                        style: TextStyle(fontSize: 14.0, color: Colors.white70),
                      ),
                      Text(
                        _formatDuration(totalDuration),
                        style: TextStyle(fontSize: 14.0, color: Colors.white70),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
