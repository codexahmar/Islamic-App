import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  String _currentLocation = 'Fetching location...';
  bool _isLoading = true;
  StreamSubscription<Position>? _positionStreamSubscription;

  String get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;

  LocationProvider() {
    _initLocationService();
  }

  Future<void> _initLocationService() async {
    _isLoading = true;
    notifyListeners();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _currentLocation = 'Location services are disabled';
      _isLoading = false;
      notifyListeners();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _currentLocation = 'Location permissions are denied';
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _currentLocation = 'Location permissions are permanently denied';
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Start listening to location changes
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    ).listen((Position position) {
      _updateLocation(position);
    });
  }

  Future<void> _updateLocation(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _currentLocation = place.locality ?? 'City not found';
      } else {
        _currentLocation = 'City not found';
      }
    } catch (e) {
      _currentLocation = 'Location not available';
      print("Error fetching location: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshLocation() {
    _initLocationService();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
