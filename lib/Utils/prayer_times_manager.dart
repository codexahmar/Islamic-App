// prayer_time_manager.dart

import 'package:flutter/material.dart';

import '../Services/prayer_times_services.dart';
import '../generated/l10n.dart';
import 'prayer_time_calc.dart';

class PrayerTimeManager extends ChangeNotifier {
  Map<String, DateTime> _timings = {};
  String _prayerName = "Loading...";
  String _prayerTime = "Loading...";
  String _nextPrayer = "Loading...";

  Map<String, DateTime> get timings => _timings;
  String get prayerName => _prayerName;
  String get prayerTime => _prayerTime;
  String get nextPrayer => _nextPrayer;

  Future<void> fetchPrayerTimes([BuildContext? context]) async {
    final service = PrayerTimesService();
    try {
      final fetchedTimings = await service.getPrayerTimes();

      _timings = fetchedTimings;

      if (context != null) {
        final l10n = S.of(context);
        final localizedPrayerNames = {
          'Fajr': l10n.fajr,

          'Dhuhr': l10n.dhuhr,
          'Asr': l10n.asr,
          'Maghrib': l10n.maghrib,
          'Isha': l10n.isha,
        };

        final prayerTimes = PrayerTimeCalculator.calculateNextPrayerTime(
            _timings, localizedPrayerNames);

        _prayerName = prayerTimes['prayerName']!;
        _prayerTime = prayerTimes['prayerTime']!;
        _nextPrayer = prayerTimes['nextPrayer']!;
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching prayer times: $e");
      _prayerName = "Error";
      _prayerTime = "Error";
      _nextPrayer = "Error";

      notifyListeners();
    }
  }

  static List<String> get prayersToSchedule =>
      ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
}
