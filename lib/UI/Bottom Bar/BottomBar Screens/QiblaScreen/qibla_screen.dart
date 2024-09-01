import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qibla_direction/qibla_direction.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:async';
import 'dart:math';
import 'package:quran_app/generated/l10n.dart';

import '../../../Widgets/location_widget.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({Key? key}) : super(key: key);

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

class _QiblahScreenState extends State<QiblahScreen> {
  double? _qiblaDirection;
  StreamSubscription<Position>? _positionStreamSubscription;
  String _selectedImage =
      'assets/images/qibla_compass.png'; // Track selected image

  @override
  void initState() {
    super.initState();
    _initializeQiblaDirection();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeQiblaDirection() async {
    await _checkLocationPermission();
    _getQiblaDirection();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is required for this feature.'),
          ),
        );
      }
      return;
    }
  }

  Future<void> _getQiblaDirection() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final coordinate = Coordinate(
        position.latitude,
        position.longitude,
      );
      final direction = await QiblaDirection.find(coordinate);

      if (mounted) {
        setState(() {
          _qiblaDirection = direction;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Error determining Qibla direction. Please try again.'),
          ),
        );
      }
    }
  }

  double _normalizeDegree(double degree) {
    return (degree + 360) % 360;
  }

  void _onImageTap(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(
            S.of(context).qibla,
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LocationWidget(),
            ),
          ],
        ),
        body: Column(
          children: [
            // Container with three images
            Container(
              margin: const EdgeInsets.all(16.0), // Fixed margin
              padding: const EdgeInsets.all(8.0), // Fixed padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(12.0), // Fixed border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Qibla 1
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _onImageTap('assets/images/qibla_compass.png'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightGreen[100],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.all(4.0), // Fixed padding
                          child: SizedBox(
                            height: 90.0, // Fixed height
                            width: 85.0, // Fixed width
                            child: Image.asset(
                              'assets/images/qibla_compass.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Qibla 1',
                        style: GoogleFonts.poppins(
                          fontSize: 16.0, // Fixed font size
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  // Qibla 2
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _onImageTap('assets/images/qibla_compass2.png'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightGreen[100],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.all(4.0), // Fixed padding
                          child: SizedBox(
                            height: 90.0, // Fixed height
                            width: 85.0, // Fixed width
                            child: Image.asset(
                              'assets/images/qibla_compass2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Qibla 2',
                        style: GoogleFonts.poppins(
                          fontSize: 16.0, // Fixed font size
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  // Qibla 3
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _onImageTap('assets/images/qibla_compass3.png'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightGreen[100],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.all(4.0), // Fixed padding
                          child: SizedBox(
                            height: 90.0, // Fixed height
                            width: 85.0, // Fixed width
                            child: Image.asset(
                              'assets/images/qibla_compass3.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Qibla 3',
                        style: GoogleFonts.poppins(
                          fontSize: 16.0, // Fixed font size
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: _qiblaDirection == null
                    ? const CircularProgressIndicator(color: Colors.white)
                    : StreamBuilder<CompassEvent>(
                        stream: FlutterCompass.events,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final direction = snapshot.data?.heading;
                            if (direction == null) {
                              return const Text("Device does not have sensors");
                            }

                            // Normalize the compass heading
                            final normalizedHeading =
                                _normalizeDegree(direction);

                            // Calculate the rotation angle needed
                            final rotationAngle =
                                ((_qiblaDirection ?? 0) - normalizedHeading) *
                                    (pi / 180);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle:
                                          rotationAngle, // Rotate based on Qibla direction
                                      child: Image.asset(
                                        _selectedImage, // Use selected image
                                        height: 200.0, // Fixed height
                                        width: 200.0, // Fixed width
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "${normalizedHeading.toInt()}° Qibla",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0, // Fixed font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
