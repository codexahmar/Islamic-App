import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<String> getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return "Location services are disabled";
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return "Location permission denied";
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    // Use the geocoding package to convert coordinates to an address
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return place.locality ??
          "City not found"; // Return the city name or a default message
    } else {
      return "City not found"; // Handle case when no placemarks are returned
    }
  }
}
