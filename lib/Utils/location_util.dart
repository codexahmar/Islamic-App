import 'package:geolocator/geolocator.dart';
import 'package:qibla_direction/qibla_direction.dart';

class LocationUtil {
  static Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return false;
    }
    return true;
  }

  static Future<double?> getQiblaDirection() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final coordinate = Coordinate(
        position.latitude,
        position.longitude,
      );
      return await QiblaDirection.find(coordinate);
    } catch (e) {
      return null;
    }
  }
}
