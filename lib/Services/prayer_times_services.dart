import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';

class PrayerTimesService {
  Future<Map<String, DateTime>> getPrayerTimes() async {
    try {
      // Fetch current location with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Create the coordinates object from latitude and longitude
      final coordinates = Coordinates(position.latitude, position.longitude);

      // Define the calculation method (Muslim World League in this case)
      final params = CalculationMethod.umm_al_qura.getParameters();
      params.madhab = Madhab.hanafi; // Optional: Set madhab if needed

      // Create prayer times instance for today
      final prayerTimes = PrayerTimes.today(coordinates, params);

      // Return a map of prayer times, ensuring they are in local time
      return {
        'Fajr': prayerTimes.fajr.toLocal(),
        'Sunrise': prayerTimes.sunrise.toLocal(),
        'Dhuhr': prayerTimes.dhuhr.toLocal(),
        'Asr': prayerTimes.asr.toLocal(),
        'Maghrib': prayerTimes.maghrib.toLocal(),
        'Isha': prayerTimes.isha.toLocal(),
      };
    } catch (e) {
      print("Error fetching prayer times: $e");
      rethrow; // Rethrow the exception for handling in the UI
    }
  }
}
