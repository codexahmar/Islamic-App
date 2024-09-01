import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  String _currentLocation = 'Fetching location...';

  String get currentLocation => _currentLocation;

  LocationProvider() {
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

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

      notifyListeners();
    } catch (e) {
      _currentLocation = 'Location not available';
      print("Error fetching location: $e");
      notifyListeners();
    }
  }
}
