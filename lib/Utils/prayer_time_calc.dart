import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;

class PrayerTimeCalculator {
  static Map<String, String> calculateNextPrayerTime(
      Map<String, DateTime> timings, Map<String, String> localizedPrayerNames) {
    final now = DateTime.now();
    DateTime fajr = timings['Fajr'] ?? now;
    DateTime sunrise = timings['Sunrise'] ?? now;
    DateTime dhuhr = timings['Dhuhr'] ?? now;
    DateTime asr = timings['Asr'] ?? now;
    DateTime maghrib = timings['Maghrib'] ?? now;
    DateTime isha = timings['Isha'] ?? now;

    String prayerName = "";
    String prayerTime = "";
    String nextPrayer = "";

    if (now.isBefore(fajr)) {
      prayerName = localizedPrayerNames['Fajr']!;
      prayerTime = DateFormat.jm().format(fajr);
      nextPrayer = _formatNextPrayer(
        localizedPrayerNames['Fajr']!,
        DateFormat.jm().format(fajr),
      );
    } else if (now.isBefore(sunrise)) {
      prayerName = localizedPrayerNames['Sunrise']!;
      prayerTime = DateFormat.jm().format(sunrise);
      nextPrayer = _formatNextPrayer(
        localizedPrayerNames['Sunrise']!,
        DateFormat.jm().format(sunrise),
      );
    } else if (now.isBefore(dhuhr)) {
      prayerName = localizedPrayerNames['Dhuhr']!;
      prayerTime = DateFormat.jm().format(dhuhr);
      nextPrayer = _formatNextPrayer(
        localizedPrayerNames['Dhuhr']!,
        DateFormat.jm().format(dhuhr),
      );
    } else if (now.isBefore(asr)) {
      prayerName = localizedPrayerNames['Asr']!;
      prayerTime = DateFormat.jm().format(asr);
      nextPrayer = _formatNextPrayer(
        localizedPrayerNames['Asr']!,
        DateFormat.jm().format(asr),
      );
    } else if (now.isBefore(maghrib)) {
      prayerName = localizedPrayerNames['Maghrib']!;
      prayerTime = DateFormat.jm().format(maghrib);
      nextPrayer = _formatNextPrayer(
        localizedPrayerNames['Maghrib']!,
        DateFormat.jm().format(maghrib),
      );
    } else if (now.isBefore(isha)) {
      prayerName = localizedPrayerNames['Isha']!;
      prayerTime = DateFormat.jm().format(isha);
      nextPrayer = _formatNextPrayer(
        localizedPrayerNames['Isha']!,
        DateFormat.jm().format(isha),
      );
    } else {
      prayerName = localizedPrayerNames['Fajr']!;
      prayerTime = DateFormat.jm().format(fajr.add(Duration(days: 1)));
      nextPrayer = _formatNextPrayer(
        localizedPrayerNames['Fajr']!,
        DateFormat.jm().format(fajr.add(Duration(days: 1))),
      );
    }

    return {
      'prayerName': prayerName,
      'prayerTime': prayerTime,
      'nextPrayer': nextPrayer,
    };
  }

  static String _formatNextPrayer(String prayerName, String prayerTime) {
    return intl.Intl.message(
      'Next Prayer: $prayerName at $prayerTime',
      name: 'nextPrayer',
      args: [prayerName, prayerTime],
      desc: 'Message indicating the next prayer time',
    );
  }
}
